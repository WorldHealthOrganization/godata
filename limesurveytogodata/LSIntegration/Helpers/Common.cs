using System;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Text;
using LSIntegration.Helpers;
using LSIntegration.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using JsonRPCclient;
using System.Configuration;

namespace LSIntegration.Helpers
{
    public class Common
    {
        public static bool IsSurveyIDExists(string id)
        {
            bool status = false;

            //Create LimeSurvey_Master.txt if not exists. Process need to check if limesurvey id exists.
            LimeSurvey_Master_Exists();

            //##web
            //string strDir = System.Web.Hosting.HostingEnvironment.MapPath(AppSettings.LogFolder); 
            string strDir = AppSettings.LogFolder;
            string strLogFile = "LimeSurvey_Master.txt";
            string[] lines = System.IO.File.ReadAllLines(strDir + strLogFile);          

            //string[] lines = System.IO.File.ReadAllLines(@"C:\Users\Public\TestFolder\WriteLines2.txt");

            for (var i = 0; i < lines.Length; i++)
            {
                if (i != 0) //avoid read first line(header)
                {
                    string[] array = lines[i].Split('|');
                    if (array[0] == id)
                    {
                        //survey id exists
                        status = true;
                        break;
                    }
                }
            }
            return status;
        }

        public static void LimeSurveyMaster(string strLog)
        {
            //Master log file to store all processed id
            string _new = "N";
            string _firstLog = "";
            StreamWriter log;
            FileStream fileStream = null;
            DirectoryInfo logDirInfo = null;
            FileInfo logFileInfo;

            //string logFilePath = "C:\\Go.Data\\synch\\logs\\"; //window
            //string logFilePath = System.Web.Hosting.HostingEnvironment.MapPath(AppSettings.LogFolder); //web
            string logFilePath = AppSettings.LogFolder;
            //logFilePath = logFilePath + "Log-" + System.DateTime.Today.ToString("dd-MM-yyyy") + "." + "txt";
            logFilePath = logFilePath + "LimeSurvey_Master" + "." + "txt";
            logFileInfo = new FileInfo(logFilePath);
            logDirInfo = new DirectoryInfo(logFileInfo.DirectoryName);
            if (!logDirInfo.Exists) logDirInfo.Create();
            if (!logFileInfo.Exists)
            {
                _new = "Y";
                _firstLog = strLog;
                fileStream = logFileInfo.Create();
                strLog = "SurveyID|Status|TimeStamp";
            }
            else
            {
                fileStream = new FileStream(logFilePath, FileMode.Append);
            }
            log = new StreamWriter(fileStream);
            log.WriteLine(strLog);
            log.Close();

            //New created file with header, need to write the log again
            if (_new == "Y")
            {
                fileStream = new FileStream(logFilePath, FileMode.Append);
                log = new StreamWriter(fileStream);
                log.WriteLine(_firstLog);
                log.Close();
            }
        }

        public static void LimeSurveyLog(string strLog)
        {
            //Log file to store every execution
            string _new = "N";
            string _firstLog = "";
            StreamWriter log;
            FileStream fileStream = null;
            DirectoryInfo logDirInfo = null;
            FileInfo logFileInfo;

            //string logFilePath = "C:\\Go.Data\\synch\\logs\\"; //window
            //string logFilePath = System.Web.Hosting.HostingEnvironment.MapPath(AppSettings.LogFolder); //web
            string logFilePath = AppSettings.LogFolder;
            //logFilePath = logFilePath + "Log-" + System.DateTime.Today.ToString("dd-MM-yyyy") + "." + "txt";
            logFilePath = logFilePath + "LimeSurvey_Log" + "." + "txt";
            logFileInfo = new FileInfo(logFilePath);
            logDirInfo = new DirectoryInfo(logFileInfo.DirectoryName);
            if (!logDirInfo.Exists) logDirInfo.Create();
            if (!logFileInfo.Exists)
            {
                _new = "Y";
                _firstLog = strLog;
                fileStream = logFileInfo.Create();
                strLog = "TimeStamp | Record Processed";
            }
            else
            {
                fileStream = new FileStream(logFilePath, FileMode.Append);
            }
            log = new StreamWriter(fileStream);
            log.WriteLine(strLog);
            log.Close();

            //New created file with header, need to write the log again
            if (_new == "Y")
            {
                fileStream = new FileStream(logFilePath, FileMode.Append);
                log = new StreamWriter(fileStream);
                log.WriteLine(_firstLog);
                log.Close();
            }
        }

        public static void LimeSurvey_Master_Exists()
        {
            //check log file exists, if not it will auto create
            string _CreateHeader = "";
            StreamWriter log;
            FileStream fileStream = null;
            DirectoryInfo logDirInfo = null;
            FileInfo logFileInfo;

            string logFilePath = AppSettings.LogFolder;
            logFilePath = logFilePath + "LimeSurvey_Master" + "." + "txt";
            logFileInfo = new FileInfo(logFilePath);
            logDirInfo = new DirectoryInfo(logFileInfo.DirectoryName);
            if (!logDirInfo.Exists) logDirInfo.Create();
            if (!logFileInfo.Exists)
            {
                fileStream = logFileInfo.Create();
                _CreateHeader = "SurveyID|Status|TimeStamp";
                log = new StreamWriter(fileStream);
                log.WriteLine(_CreateHeader);
                log.Close();
            }
        }

        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }

        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }

        // recursively yield all children of json
        public static IEnumerable<JToken> AllChildren(JToken json)
        {
            foreach (var c in json.Children())
            {
                yield return c;
                foreach (var cc in AllChildren(c))
                {
                    yield return cc;
                }
            }
        }

        public LoginTokenDto GetLoginDetails(string email, string password, string BaseURL)
        {
            //Mainly to get go.data access token
            LoginTokenDto lt = new LoginTokenDto() { username = email, password = password };
            string json = ConvertToJSON_String(lt);

            string response_text = ExecuteApiRequest_JSON(json, BaseURL);
            dynamic response_json = ConvertFromJSON(response_text);

            int l = response_text.Length - 12;
            string str = response_text.Substring(12, l);

            int r = str.Length - 1;
            string str2 = str.Substring(0, r);
            json = "[" + str2 + "]";

            var objDto = JsonConvert.DeserializeObject<List<LoginTokenDto>>(json.ToString());

            lt.access_token = objDto[0].access_token;
            lt.token_type = objDto[0].token_type;
            lt.expires_in = objDto[0].expires_in;

            return lt;
        }

        public JArray GET_Outbreaks_ALL(string token)
        {
            //Testing
            string LAST_METHOD_CALL = string.Empty;
            try
            {
                string method_name = "outbreaks?access_token={0}";
                string method_call_name = string.Format(method_name, token);

                LAST_METHOD_CALL = method_call_name;
                return GET_ARRAY(method_call_name);
            }
            catch { throw; }
        }

        public bool POST_FollowUps(LimeSurveyDto LSDetailsByToken, string personId, string SessionKey)
        {
            //Populate json format with data and post to go.data
            bool status = false;
            //string personId = "3c493744-65ce-40ca-96ca-db4175ae0a8d"; //test personId
            try
            {
                FollowUpsDto model = new FollowUpsDto();
                FollowUpsAddressDto model_fu_address = new FollowUpsAddressDto();

                //create subList for address
                List<FollowUpsAddressDto> addressList = new List<FollowUpsAddressDto>();

                #region Questionaire/ Answer
                //create subList for questionaire answer
                List<FollowUpsQnADto> QuestionaireAnswerList = new List<FollowUpsQnADto>();

                //create subList for questionaire answer/fever_38_c
                //string.IsNullOrEmpty(LSDetailsByToken.HaveTempSQ001)
                
                string haveTemp = LSDetailsByToken.HaveTempSQ001.ToString() == "Y" ? "Yes" : "No";
                string[] arr_fever_38_c = new string[] { haveTemp };
                List<FollowUpsQnAValueDto> QnA_fever_38_c = new List<FollowUpsQnAValueDto>();
                QnA_fever_38_c.Add(new FollowUpsQnAValueDto { value = arr_fever_38_c });

                //create subList for questionaire answer/respiratory_symptoms
                string rs_Cough = LSDetailsByToken.CurrentRespSymptoms002 == "Y" ? "Cough" : "";
                string rs_ShortnessOfBreath = LSDetailsByToken.CurrentRespSymptoms003 == "Y" ? "shortness of breath" : "";
                string[] arr_respiratory_symptoms = new string[] { rs_Cough, rs_ShortnessOfBreath };
                List<FollowUpsQnAValueDto> QnA_respiratory_symptoms = new List<FollowUpsQnAValueDto>();
                QnA_respiratory_symptoms.Add(new FollowUpsQnAValueDto { value = arr_respiratory_symptoms });

                //create subList for questionaire answer/general_symptoms
                string gs_Headaches = LSDetailsByToken.CurrentGenSymptoms002 == "Y" ? "headaches" : "";
                string gs_Chills = LSDetailsByToken.CurrentGenSymptoms003 == "Y" ? "chills" : "";
                string gs_Sweats = LSDetailsByToken.CurrentGenSymptoms004 == "Y" ? "sweats" : "";
                string gs_Fatigue = LSDetailsByToken.CurrentGenSymptoms005 == "Y" ? "fatigue" : "";
                string gs_MuscleAches = LSDetailsByToken.CurrentGenSymptoms006 == "Y" ? "muscle aches" : "";
                string gs_JointAches = LSDetailsByToken.CurrentGenSymptoms007 == "Y" ? "joint aches" : "";
                string gs_Rash = LSDetailsByToken.CurrentGenSymptoms008 == "Y" ? "rash" : "";
                string[] arr_general_symptoms = new string[] { gs_Headaches, gs_Chills, gs_Sweats, gs_Fatigue, gs_MuscleAches, gs_JointAches, gs_Rash };
                List<FollowUpsQnAValueDto> QnA_general_symptoms = new List<FollowUpsQnAValueDto>();
                QnA_general_symptoms.Add(new FollowUpsQnAValueDto { value = arr_general_symptoms });

                //create subList for questionaire answer/ent_opthalmic_symptoms
                string ent_Anosmia = LSDetailsByToken.CurrentENTSymptoms002 == "Y" ? "anosmia" : "";
                string ent_Aguesia = LSDetailsByToken.CurrentENTSymptoms003 == "Y" ? "aguesia" : "";
                string ent_Sorethroat = LSDetailsByToken.CurrentENTSymptoms004 == "Y" ? "sorethroat" : "";
                string ent_Rhinitis = LSDetailsByToken.CurrentENTSymptoms005 == "Y" ? "rhinitis" : "";
                string ent_Nosebleed = LSDetailsByToken.CurrentENTSymptoms006 == "Y" ? "nosebleed" : "";
                string ent_Conjonctivitis = LSDetailsByToken.CurrentENTSymptoms007 == "Y" ? "Conjonctivitis" : "";
                string[] arr_ent_opthalmic_symptoms = new string[] { ent_Anosmia, ent_Aguesia, ent_Sorethroat, ent_Rhinitis, ent_Nosebleed, ent_Conjonctivitis };
                List<FollowUpsQnAValueDto> QnA_ent_opthalmic_symptoms = new List<FollowUpsQnAValueDto>();
                QnA_ent_opthalmic_symptoms.Add(new FollowUpsQnAValueDto { value = arr_ent_opthalmic_symptoms });

                //create subList for questionaire answer/gastrointestinal_symptoms
                string gas_Vomiting = LSDetailsByToken.CurrentGastrSymptoms002 == "Y" ? "Vomiting" : "";
                string gas_Nauseag = LSDetailsByToken.CurrentGastrSymptoms003 == "Y" ? "nausea" : "";
                string gas_Diarrhea = LSDetailsByToken.CurrentGastrSymptoms004 == "Y" ? "diarrhea" : "";
                string gas_LossOfAppetite = LSDetailsByToken.CurrentGastrSymptoms005 == "Y" ? "loss of appetite" : "";
                string[] arr_gastrointestinal_symptoms = new string[] { gas_Vomiting, gas_Nauseag, gas_Diarrhea, gas_LossOfAppetite };
                List<FollowUpsQnAValueDto> QnA_gastrointestinal_symptoms = new List<FollowUpsQnAValueDto>();
                QnA_gastrointestinal_symptoms.Add(new FollowUpsQnAValueDto { value = arr_gastrointestinal_symptoms });

                //create subList for questionaire answer/neurological_symptoms
                //"Loss of consciousness" availabe in go.data questionaire, but not exist in go.data api
                string neu_Seizures = LSDetailsByToken.CurrentNeuroSymptoms002 == "Y" ? "Seizures" : "";
                string neu_LossOfConsciousness = LSDetailsByToken.CurrentNeuroSymptoms003 == "Y" ? "Loss of consciousness" : "";
                //string neu_sym = neu_Seizures != "" ? neu_Seizures : neu_LossOfConsciousness;
                string[] arr_neurological_symptoms = new string[] { neu_Seizures, neu_LossOfConsciousness }; //api not workable if add neu_LossOfConsciousness
                List<FollowUpsQnAValueDto> QnA_neurological_symptoms = new List<FollowUpsQnAValueDto>();
                QnA_neurological_symptoms.Add(new FollowUpsQnAValueDto { value = arr_neurological_symptoms });

                //create subList for questionaire answer/Temperature_details
                string tem_celsius = LSDetailsByToken.CurrentTemp != null ? LSDetailsByToken.CurrentTemp : "";
                string[] arr_Temperature_details = new string[] { tem_celsius };
                List<FollowUpsQnAValueDto> QnA_Temperature_details = new List<FollowUpsQnAValueDto>();
                QnA_Temperature_details.Add(new FollowUpsQnAValueDto { value = arr_Temperature_details });

                //create subList for questionaire answer/other
                string oth_desc = LSDetailsByToken.OtherSymptoms != null ? LSDetailsByToken.OtherSymptoms : "";
                string[] arr_other = new string[] { oth_desc };
                List<FollowUpsQnAValueDto> QnA_other = new List<FollowUpsQnAValueDto>();
                QnA_other.Add(new FollowUpsQnAValueDto { value = arr_other });

                #endregion

                //create sublist for address/geoLocation
                List<FollowUpsAddressGeoLocationDto> geoLocationsList = new List<FollowUpsAddressGeoLocationDto>();
                geoLocationsList.Add(new FollowUpsAddressGeoLocationDto { lat = 0, lng = 0 });

                model.date = DateTime.Now;
                model.statusId = "LNG_REFERENCE_DATA_CONTACT_DAILY_FOLLOW_UP_STATUS_TYPE_SEEN_ OK";
                model.address = addressList; //new List<FollowUpsAddressDto>();
                model.address.Add(new FollowUpsAddressDto
                {
                    typeId = "LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_USUAL_PLACE_OF_RESIDENCE",
                    country = "",
                    city = "",
                    addressLine1 = "",
                    postalCode = "",
                    locationId = "",
                    geoLocation = geoLocationsList,
                    geoLocationAccurate = false,
                    date = DateTime.Now,
                    phoneNumber = "",
                    emailAddress = ""
                });
                model.usualPlaceOfResidenceLocationId = "";
                model.questionnaireAnswers = QuestionaireAnswerList;
                model.questionnaireAnswers.Add(new FollowUpsQnADto
                {
                    fever_38_c = QnA_fever_38_c,
                    respiratory_symptoms = QnA_respiratory_symptoms,
                    general_symptoms = QnA_general_symptoms,
                    ent_opthalmic_symptoms = QnA_ent_opthalmic_symptoms,
                    gastrointestinal_symptoms = QnA_gastrointestinal_symptoms,
                    neurological_symptoms = QnA_neurological_symptoms,
                    Temperature_details = QnA_Temperature_details,
                    other = QnA_other
                });
                model.index = 0;
                model.teamId = "";
                model.outbreakId = AppSettings.GoData_OutbreakID;
                model.targeted = true;
                model.comment = "";
                model.deletedByParent = "";
                model.fillLocation = geoLocationsList;
                model.id = "";
                model.createdAt = DateTime.Now;
                model.createdBy = "";
                model.updatedAt = DateTime.Now;
                model.updatedBy = "Synch GoData-DataForm";
                model.createdOn = "";
                model.deleted = false;
                model.deletedAt = DateTime.Now;
                model.personId = personId;

                string json = ConvertToJSON_String(model);

                //manual syntax handling for fever_38_c
                json = json.Replace("\"fever_38_c\":[{\"value\":[", "\"fever_38_c\":[{\"value\":");
                json = json.Replace("]}],\"respiratory_symptoms", "}],\"respiratory_symptoms");

                //manual syntax handling for questionnaireAnswers
                json = json.Replace("\"questionnaireAnswers\":[", "\"questionnaireAnswers\":");
                json = json.Replace("}],\"index\"", "},\"index\"");

                //manual syntax handling for neurological_symtoms
                //TODO: remove below handling if neurological api allow to select multiple
                //json = json.Replace("\"neurological_symptoms\":[{\"value\":[", "\"neurological_symptoms\":[{\"value\":");
                //json = json.Replace("]}],\"Temperature_details\"", "}],\"Temperature_details\"");

                //BaseUrl = ../api/outbreaks/{id}/contacts/{nk}/follow-ups?access_token=xxxxxxxxxxxxxxxx
                //Request URL = "http://godata_shw.who.int/api/outbreaks/36b237a0-d288-4218-9db8-491a91afdf3e/contacts/e5795fb2-32d6-47aa-b762-f453e5264661/follow-ups?access_token=Huux6fYRP1FJmi2Wix9ZWnlqFeIPSAfTCPif1z7q9w9ru1YvvcB4PBomUmJEVtQw";

                //##POST to Go.Data
                string BaseURL = AppSettings.GoData_APIUrl + "outbreaks/" + AppSettings.GoData_OutbreakID + "/contacts/" + personId + "/follow-ups?access_token=" + SessionKey;
                string response_text = ExecuteApiRequest_JSON(json, BaseURL);
                status = true;
            }
            catch
            {
                status = false;
            }
            return status;
        }

        public string GetPersonIdByLSToken(string Lstoken)
        {
            //Mainly to get dataform personId by limesurvey token
            string personId = GetLimeSurveyListParticipants(Lstoken);
            return personId;
        }

        public string GetGoDataAccessToken()
        {
            //Get go.data access token
            LoginTokenDto model = new LoginTokenDto();
            Common result = new Common();

            string Username = AppSettings.GoData_UserName;
            string Password = AppSettings.GoData_Password;
            string BaseURL = AppSettings.GoData_APIUrl;
            string Method_Oauth = "oauth/token?access_token=Token";
            model = result.GetLoginDetails(Username, Password, BaseURL + Method_Oauth);
            return model.access_token;
        }

        public string GetLimeSurveySessionKey()
        {
            //Get lime survey session key
            string Baseurl = AppSettings.DataFormRemoteControlURL;
            LSJsonRPCclient client = new LSJsonRPCclient(Baseurl);
            client.Method = "get_session_key";
            client.Parameters.Add("username", AppSettings.LimeSurveyUserName);
            client.Parameters.Add("password", AppSettings.LimeSurveyPwd);
            client.Post();
            string SessionKey = client.Response.result.ToString();
            return SessionKey;
        }

        public string GetLimeSurveyListParticipants(string Lstoken)
        {
            //Get dataform.lastname by calling limesurvey.list_participants via limesurvey token
            string Baseurl = AppSettings.DataFormRemoteControlURL;
            LSJsonRPCclient client = new LSJsonRPCclient(Baseurl);
            string SessionKey = GetLimeSurveySessionKey();
            string personId = "";

            client.Method = "list_participants";
            client.Parameters.Add("sSessionKey", SessionKey);
            client.Parameters.Add("iSurveyID", AppSettings.LimeSurveyID);
            client.Parameters.Add("iStart", 0);
            client.Parameters.Add("iLimit", 500);
            client.Parameters.Add("bUnused", false);
            client.Parameters.Add("aAttributes", "usesleft"); //completed,usesleft
            client.Parameters.Add("aConditions", null);
            client.Post();


            if (client.Response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                string json = client.Response.result.ToString();
                json = json.Replace("\r\n", "");
                var Participants_Model = JsonConvert.DeserializeObject<List<ListParticipantsDto>>(json.ToString());

                if (Participants_Model.Count > 0)
                {
                    for (var i = 0; i < Participants_Model.Count; i++)
                    {
                        if (Participants_Model[i].token == Lstoken)
                        {
                            personId = Participants_Model[i].participant_info.lastname.ToString();
                            break;
                        }
                    }
                }
            }
            return personId;
        }

        #region Method/function from old program

        public string ExecuteApiRequest_JSON(string sContent, string baseURL, string TYPE_OF_CALL = "POST")
        {
            string _url = string.Empty;
            string _response = string.Empty;

            try
            {
                //_url = GET_REQUEST_URL(callURL);
                _url = baseURL;

                using (var client = NEW_WEBCLIENT_OBJECT)
                {
                    client.Headers[HttpRequestHeader.ContentType] = "application/json";
                    client.Headers[HttpRequestHeader.Accept] = "application/json";

                    var data = Encoding.UTF8.GetBytes(sContent);
                    byte[] result = client.UploadData(_url, TYPE_OF_CALL, data);

                    _response = GET_STRING(result);
                }

                return _response;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string API_URL { get; private set; }//API_URL

        public WebClient NEW_WEBCLIENT_OBJECT
        {
            get
            {
                //System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;

                var client = new WebClient();
                return client;
            }
        }

        public string GET_REQUEST_URL(string callName, string API_URL)
        {
            return string.Format("{0}{1}{2}", API_URL, (API_URL.EndsWith("/") ? "" : "/"), callName);
        }//GET_REQUEST_URL

        public string GET_STRING(byte[] bytes)
        {
            /*
            //char[] chars = new char[bytes.Length / sizeof(char)];
            char[] chars = new char[(bytes.Length + (bytes.Length % 2)) / sizeof(char)];
            System.Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
            return new string(chars);
            */

            string str = Encoding.UTF8.GetString(bytes);
            return str;
        }//GET_STRING

        public static string ConvertToJSON_String(object obj)
        {
            try
            {
                string json = JsonConvert.SerializeObject(obj, JSON_SERIALIZER_SETTINGS);
                return json;
            }
            catch { throw; }
        }

        public static object ConvertFromJSON(string jsonContent) { return JsonConvert.DeserializeObject(jsonContent, JSON_SERIALIZER_SETTINGS); }

        public static T ConvertFromJSON<T>(string jsonContent) { return JsonConvert.DeserializeObject<T>(jsonContent, JSON_SERIALIZER_SETTINGS); }

        public static JsonSerializerSettings JSON_SERIALIZER_SETTINGS
        {
            get { return new JsonSerializerSettings() { DateFormatString = Reference.DateFormat.DEFAULT_DATE_FORMAT, Formatting = Formatting.None, DateParseHandling = DateParseHandling.None }; }
        }

        public JArray GET_ARRAY(string method_call_name)
        {
            try
            {
                string response_text = ExecuteApiRequest(method_call_name);
                JArray response_array = ConvertFromJSON<JArray>(response_text);
                return response_array;
            }//try
            catch (Exception) { throw; }//catch
        }//GET_ARRAY

        public string ExecuteApiRequest(string callURL, bool response_is_encrypted = false)
        {
            string _url = string.Empty;
            string _response = string.Empty;

            try
            {
                callURL = AppSettings.GoData_APIUrl + callURL;
                //_url = GET_REQUEST_URL(callURL);
                _url = callURL;

                using (var client = NEW_WEBCLIENT_OBJECT)// new WebClient())
                {
                    //if ( !response_is_encrypted)
                    client.Headers[HttpRequestHeader.Accept] = "application/json";

                    //_response = client.DownloadString(_url);
                    _response = WEBCLIENT_DOWNLOAD_STRING(client, _url);
                }

                return _response;
            }
            catch { throw; }
        }

        public string GET_REQUEST_URL(string callName)
        {
            return string.Format("{0}{1}{2}", API_URL, (API_URL.EndsWith("/") ? "" : "/"), callName);
        }//GET_REQUEST_URL

        public string WEBCLIENT_DOWNLOAD_STRING(WebClient client, string callURL)
        {
            try
            {
                try
                {
                    byte[] bytes = client.DownloadData(callURL);
                    string response = Encoding.UTF8.GetString(bytes);
                    return response;
                }
                catch (Exception ex)
                {
                    string webex_response = string.Empty;

                    if (ex is WebException)
                    {
                        WebException we = (WebException)ex;
                        if (we.Status == WebExceptionStatus.ProtocolError)
                        {
                            HttpWebResponse response = (HttpWebResponse)we.Response;

                            if ((int)response.StatusCode == 500)
                                using (StreamReader sr = new StreamReader(response.GetResponseStream()))
                                    webex_response = sr.ReadToEnd();
                        }
                    }
                    throw ex;
                }
            }
            catch { throw; }//catch
        }

        #endregion
    }
}