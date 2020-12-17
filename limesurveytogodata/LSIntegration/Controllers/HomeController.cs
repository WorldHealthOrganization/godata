using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using JsonRPCclient;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using LSIntegration.Models;
using LSIntegration.Helpers;


namespace LSIntegration.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult GetLimeSurveyAPI()
        {

            bool status = false;
            string message = "";
            string totalCount = "";

            //#Get LimeSurvey SessionKey
            string Baseurl = AppSettings.DataFormRemoteControlURL; 
            LSJsonRPCclient client = new LSJsonRPCclient(Baseurl);
            client.Method = "get_session_key";
            client.Parameters.Add("username", AppSettings.LimeSurveyUserName);
            client.Parameters.Add("password", AppSettings.LimeSurveyPwd);
            client.Post();
            string SessionKey = client.Response.result.ToString();

            client.ClearParameters();

            if (client.Response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                //#Get all follow-up record from LimeSurvey
                client.Method = "export_responses";
                client.Parameters.Add("sSessionKey", SessionKey);
                client.Parameters.Add("iSurveyID", AppSettings.LimeSurveyID);
                client.Parameters.Add("sDocumentType", AppSettings.LimeSurvey_sDocumentType);
                client.Parameters.Add("sLanguageCode", string.IsNullOrEmpty(AppSettings.LimeSurvey_sLanguageCode)? null: AppSettings.LimeSurvey_sLanguageCode);
                client.Parameters.Add("sCompletionStatus", AppSettings.LimeSurvey_sCompletionStatus);
                client.Parameters.Add("sHeadingType", AppSettings.LimeSurvey_sHeadingType);
                client.Parameters.Add("sResponseType", AppSettings.LimeSurvey_sResponseType);
                client.Parameters.Add("iFromResponseID", string.IsNullOrEmpty(AppSettings.LimeSurvey_iFromResponseID) ? null : AppSettings.LimeSurvey_iFromResponseID);
                client.Parameters.Add("iToResponseID", string.IsNullOrEmpty(AppSettings.LimeSurvey_iToResponseID) ? null : AppSettings.LimeSurvey_iToResponseID);
                client.Parameters.Add("aFields", null);
                client.Post();
            }

            if (client.Response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                status = true;
                message = Common.Base64Decode(client.Response.result.ToString());
            }

            //GetJsonFormat(message, SessionKey);
            totalCount = TransferLimeSurveyToGoData(message, SessionKey);

            #region Sample Json

            // get just the person you're interested in
            //data = data.Where(d => d.Custnumber == "123SC").ToList();

            // serialize back to JSON
            //ms = new MemoryStream();
            //ser.WriteObject(ms, data);
            //ms.Position = 0;
            //json = Encoding.UTF8.GetString(ms.ToArray());
            //ms.Close();


            //if (client.Response.StatusCode == System.Net.HttpStatusCode.OK)
            //{
            //    client.Method = "import_survey";
            //    client.Parameters.Add("sSessionKey", SessionKey);
            //    client.Parameters.Add("sImportData", Base64Encode(yourImportDataString));
            //    client.Parameters.Add("sImportDataType", "lss");
            //    //client.Parameters.Add("sNewSurveyName", "test");
            //    //client.Parameters.Add("DestSurveyID", 1);
            //    client.Post();
            //}

            //client.ClearParameters();

            //Console.WriteLine("new survey id:" + client.Response.result.ToString());
            //Console.ReadLine();
            #endregion

            return Json(new { json_status = status, json_message = "Total record processed: "+totalCount }, JsonRequestBehavior.AllowGet);
        }

        public string TransferLimeSurveyToGoData(string json, string SessionKey)
        {
            bool status = false;
            //bool transfer_status = false;
            int transferred_count = 0;
            Common dal = new Common();
            List<LimeSurveyDto> mainList = new List<LimeSurveyDto>();
            //json = "{'responses':[{'60':{'id':'60','submitdate':'2020-06-19 15:12:03','lastpage':'1','startlanguage':'en','seed':'1876486666','token':'lHeB0udKq1azVjJ','startdate':'2020-06-19 15:11:43','datestamp':'2020-06-19 15:12:03','CurrentTemp':'36','HaveTemp[SQ001]':null,'CurrentRespSymptoms[001]':'Y','CurrentRespSymptoms[002]':'','CurrentRespSymptoms[003]':'','CurrentGenSymptoms[001]':'','CurrentGenSymptoms[002]':'Y','CurrentGenSymptoms[003]':'Y','CurrentGenSymptoms[004]':'','CurrentGenSymptoms[005]':'','CurrentGenSymptoms[006]':'','CurrentGenSymptoms[007]':'','CurrentGenSymptoms[008]':'','CurrentENTSymptoms[001]':'','CurrentENTSymptoms[002]':'','CurrentENTSymptoms[003]':'','CurrentENTSymptoms[004]':'Y','CurrentENTSymptoms[005]':'','CurrentENTSymptoms[006]':'','CurrentENTSymptoms[007]':'','CurrentGastrSymptoms[001]':'','CurrentGastrSymptoms[002]':'','CurrentGastrSymptoms[003]':'Y','CurrentGastrSymptoms[004]':'Y','CurrentGastrSymptoms[005]':'','CurrentNeuroSymptoms[001]':'','CurrentNeuroSymptoms[002]':'Y','CurrentNeuroSymptoms[003]':'Y','OtherSymptoms':'test Lo'}},{'61':{'id':'61','submitdate':'2020-06-19 15:12:35','lastpage':'1','startlanguage':'en','seed':'1358768884','token':'lHeB0udKq1azVjJ','startdate':'2020-06-19 15:12:11','datestamp':'2020-06-19 15:12:35','CurrentTemp':'41','HaveTemp[SQ001]':null,'CurrentRespSymptoms[001]':'','CurrentRespSymptoms[002]':'','CurrentRespSymptoms[003]':'Y','CurrentGenSymptoms[001]':'','CurrentGenSymptoms[002]':'Y','CurrentGenSymptoms[003]':'Y','CurrentGenSymptoms[004]':'Y','CurrentGenSymptoms[005]':'Y','CurrentGenSymptoms[006]':'Y','CurrentGenSymptoms[007]':'Y','CurrentGenSymptoms[008]':'','CurrentENTSymptoms[001]':'Y','CurrentENTSymptoms[002]':'','CurrentENTSymptoms[003]':'','CurrentENTSymptoms[004]':'','CurrentENTSymptoms[005]':'','CurrentENTSymptoms[006]':'','CurrentENTSymptoms[007]':'','CurrentGastrSymptoms[001]':'','CurrentGastrSymptoms[002]':'Y','CurrentGastrSymptoms[003]':'Y','CurrentGastrSymptoms[004]':'','CurrentGastrSymptoms[005]':'','CurrentNeuroSymptoms[001]':'','CurrentNeuroSymptoms[002]':'Y','CurrentNeuroSymptoms[003]':'','OtherSymptoms':''}},{'90':{'id':'90','submitdate':null,'lastpage':null,'startlanguage':'en','seed':'1215071593','token':'lHeB0udKq1azVjJ','startdate':'2020-11-30 11:00:47','datestamp':'2020-11-30 11:00:47','CurrentTemp':null,'HaveTemp[SQ001]':null,'CurrentRespSymptoms[001]':null,'CurrentRespSymptoms[002]':null,'CurrentRespSymptoms[003]':null,'CurrentGenSymptoms[001]':null,'CurrentGenSymptoms[002]':null,'CurrentGenSymptoms[003]':null,'CurrentGenSymptoms[004]':null,'CurrentGenSymptoms[005]':null,'CurrentGenSymptoms[006]':null,'CurrentGenSymptoms[007]':null,'CurrentGenSymptoms[008]':null,'CurrentENTSymptoms[001]':null,'CurrentENTSymptoms[002]':null,'CurrentENTSymptoms[003]':null,'CurrentENTSymptoms[004]':null,'CurrentENTSymptoms[005]':null,'CurrentENTSymptoms[006]':null,'CurrentENTSymptoms[007]':null,'CurrentGastrSymptoms[001]':null,'CurrentGastrSymptoms[002]':null,'CurrentGastrSymptoms[003]':null,'CurrentGastrSymptoms[004]':null,'CurrentGastrSymptoms[005]':null,'CurrentNeuroSymptoms[001]':null,'CurrentNeuroSymptoms[002]':null,'CurrentNeuroSymptoms[003]':null,'OtherSymptoms':null}}]}";

            var resultObjects = Common.AllChildren(JObject.Parse(json))
                .First(c => c.Type == JTokenType.Array && c.Path.Contains("responses"))
                .Children<JObject>();

            foreach (JObject result in resultObjects)
            {
                foreach (JProperty property in result.Properties())
                {
                    var subList = property.Value;
                    string strList = subList.ToString();
                    strList = strList.Replace("\r\n", "");
                    strList = "[" + strList + "]";

                    //string c = "[{\"id\":\"60\",\"submitdate\":\"2020-06-19 15:12:03\",\"lastpage\":\"1\",\"startlanguage\":\"en\",\"seed\":\"1876486666\",\"token\":\"lHeB0udKq1azVjJ\",\"startdate\":\"2020-06-19 15:11:43\",\"datestamp\":\"2020-06-19 15:12:03\",\"CurrentTemp\":\"36\",\"HaveTemp[SQ001]\":null,\"CurrentRespSymptoms[001]\":\"Y\",\"CurrentRespSymptoms[002]\":\"\",\"CurrentRespSymptoms[003]\":\"\",\"CurrentGenSymptoms[001]\":\"\",\"CurrentGenSymptoms[002]\":\"Y\",\"CurrentGenSymptoms[003]\":\"Y\",\"CurrentGenSymptoms[004]\":\"\",\"CurrentGenSymptoms[005]\":\"\",\"CurrentGenSymptoms[006]\":\"\",\"CurrentGenSymptoms[007]\":\"\",\"CurrentGenSymptoms[008]\":\"\",\"CurrentENTSymptoms[001]\":\"\",\"CurrentENTSymptoms[002]\":\"\",\"CurrentENTSymptoms[003]\":\"\",\"CurrentENTSymptoms[004]\":\"Y\",\"CurrentENTSymptoms[005]\":\"\",\"CurrentENTSymptoms[006]\":\"\",\"CurrentENTSymptoms[007]\":\"\",\"CurrentGastrSymptoms[001]\":\"\",\"CurrentGastrSymptoms[002]\":\"\",\"CurrentGastrSymptoms[003]\":\"Y\",\"CurrentGastrSymptoms[004]\":\"Y\",\"CurrentGastrSymptoms[005]\":\"\",\"CurrentNeuroSymptoms[001]\":\"\",\"CurrentNeuroSymptoms[002]\":\"Y\",\"CurrentNeuroSymptoms[003]\":\"Y\",\"OtherSymptoms\":\"test Lo\"},{\"id\":\"61\",\"submitdate\":\"2020-06-19 15:12:03\",\"lastpage\":\"1\",\"startlanguage\":\"en\",\"seed\":\"1876486666\",\"token\":\"lHeB0udKq1azVjJ\",\"startdate\":\"2020-06-19 15:11:43\",\"datestamp\":\"2020-06-19 15:12:03\",\"CurrentTemp\":\"36\",\"HaveTemp[SQ001]\":null,\"CurrentRespSymptoms[001]\":\"Y\",\"CurrentRespSymptoms[002]\":\"\",\"CurrentRespSymptoms[003]\":\"\",\"CurrentGenSymptoms[001]\":\"\",\"CurrentGenSymptoms[002]\":\"Y\",\"CurrentGenSymptoms[003]\":\"Y\",\"CurrentGenSymptoms[004]\":\"\",\"CurrentGenSymptoms[005]\":\"\",\"CurrentGenSymptoms[006]\":\"\",\"CurrentGenSymptoms[007]\":\"\",\"CurrentGenSymptoms[008]\":\"\",\"CurrentENTSymptoms[001]\":\"\",\"CurrentENTSymptoms[002]\":\"\",\"CurrentENTSymptoms[003]\":\"\",\"CurrentENTSymptoms[004]\":\"Y\",\"CurrentENTSymptoms[005]\":\"\",\"CurrentENTSymptoms[006]\":\"\",\"CurrentENTSymptoms[007]\":\"\",\"CurrentGastrSymptoms[001]\":\"\",\"CurrentGastrSymptoms[002]\":\"\",\"CurrentGastrSymptoms[003]\":\"Y\",\"CurrentGastrSymptoms[004]\":\"Y\",\"CurrentGastrSymptoms[005]\":\"\",\"CurrentNeuroSymptoms[001]\":\"\",\"CurrentNeuroSymptoms[002]\":\"Y\",\"CurrentNeuroSymptoms[003]\":\"Y\",\"OtherSymptoms\":\"test Lo\"}]";
                    var objDto = JsonConvert.DeserializeObject<List<LimeSurveyDto>>(strList.ToString());
                    mainList.AddRange(objDto);
                }
            }

            //post every single survey into go.data
            LimeSurveyDto LSDetailsByToken = new LimeSurveyDto();

            //##Avoid insert duplicated limesurvey id into log file
            string TimeStamp = DateTime.Now.ToString("dd-MM-yyyy HH:mm:ss");
            decimal _CurrentTemp;
            for (var i = 0; i < mainList.Count; i++)
            {
                if (!Common.IsSurveyIDExists(mainList[i].id))
                {
                    //##Get personId from method "list_participants" via lastname
                    string personId = dal.GetPersonIdByLSToken(mainList[i].token);

                    //##Populating each limesurvey record into model
                    if (!string.IsNullOrEmpty(personId))
                    {
                        LSDetailsByToken.token = mainList[i].token;
                        LSDetailsByToken.id = mainList[i].id;
                        LSDetailsByToken.submitdate = mainList[i].submitdate;
                        LSDetailsByToken.lastpage = mainList[i].lastpage;
                        LSDetailsByToken.startlanguage = mainList[i].startlanguage;
                        LSDetailsByToken.seed = mainList[i].seed;
                        LSDetailsByToken.startdate = mainList[i].startdate;
                        LSDetailsByToken.datestamp = mainList[i].datestamp;

                        LSDetailsByToken.CurrentTemp = mainList[i].CurrentTemp;

                        decimal.TryParse(mainList[i].CurrentTemp, out _CurrentTemp);
                        //_CurrentTemp = int.Parse(mainList[i].CurrentTemp);
                        if(_CurrentTemp>= 38)
                        {
                            LSDetailsByToken.HaveTempSQ001 = "Y";
                        }
                        else
                        {
                            LSDetailsByToken.HaveTempSQ001 = "N";
                        }
                        //LSDetailsByToken.HaveTempSQ001 = mainList[i].HaveTempSQ001;
                        LSDetailsByToken.CurrentRespSymptoms001 = mainList[i].CurrentRespSymptoms001;
                        LSDetailsByToken.CurrentRespSymptoms002 = mainList[i].CurrentRespSymptoms002;
                        LSDetailsByToken.CurrentRespSymptoms003 = mainList[i].CurrentRespSymptoms003;

                        LSDetailsByToken.CurrentGenSymptoms001 = mainList[i].CurrentGenSymptoms001;
                        LSDetailsByToken.CurrentGenSymptoms002 = mainList[i].CurrentGenSymptoms002;
                        LSDetailsByToken.CurrentGenSymptoms003 = mainList[i].CurrentGenSymptoms003;
                        LSDetailsByToken.CurrentGenSymptoms004 = mainList[i].CurrentGenSymptoms004;
                        LSDetailsByToken.CurrentGenSymptoms005 = mainList[i].CurrentGenSymptoms005;
                        LSDetailsByToken.CurrentGenSymptoms006 = mainList[i].CurrentGenSymptoms006;
                        LSDetailsByToken.CurrentGenSymptoms007 = mainList[i].CurrentGenSymptoms007;
                        LSDetailsByToken.CurrentGenSymptoms008 = mainList[i].CurrentGenSymptoms008;

                        LSDetailsByToken.CurrentENTSymptoms001 = mainList[i].CurrentENTSymptoms001;
                        LSDetailsByToken.CurrentENTSymptoms002 = mainList[i].CurrentENTSymptoms002;
                        LSDetailsByToken.CurrentENTSymptoms003 = mainList[i].CurrentENTSymptoms003;
                        LSDetailsByToken.CurrentENTSymptoms004 = mainList[i].CurrentENTSymptoms004;
                        LSDetailsByToken.CurrentENTSymptoms005 = mainList[i].CurrentENTSymptoms005;
                        LSDetailsByToken.CurrentENTSymptoms006 = mainList[i].CurrentENTSymptoms006;
                        LSDetailsByToken.CurrentENTSymptoms007 = mainList[i].CurrentENTSymptoms007;

                        LSDetailsByToken.CurrentGastrSymptoms001 = mainList[i].CurrentGastrSymptoms001;
                        LSDetailsByToken.CurrentGastrSymptoms002 = mainList[i].CurrentGastrSymptoms002;
                        LSDetailsByToken.CurrentGastrSymptoms003 = mainList[i].CurrentGastrSymptoms003;
                        LSDetailsByToken.CurrentGastrSymptoms004 = mainList[i].CurrentGastrSymptoms004;
                        LSDetailsByToken.CurrentGastrSymptoms005 = mainList[i].CurrentGastrSymptoms005;

                        LSDetailsByToken.CurrentNeuroSymptoms001 = mainList[i].CurrentNeuroSymptoms001;
                        LSDetailsByToken.CurrentNeuroSymptoms002 = mainList[i].CurrentNeuroSymptoms002;
                        LSDetailsByToken.CurrentNeuroSymptoms003 = mainList[i].CurrentNeuroSymptoms003;

                        LSDetailsByToken.OtherSymptoms = mainList[i].OtherSymptoms;

                        //##Get every new access token to avoid expired. But may slow down performance
                        string access_token = dal.GetGoDataAccessToken();

                        //##Post to go.data
                        status = dal.POST_FollowUps(LSDetailsByToken, personId, access_token);

                        if (status)
                        {
                            //Create or append logs/LimeSurvey_Master.txt
                            //transfer_status = true;
                            string GoDataStatus = "1";//1=success;0=failed
                            Common.LimeSurveyMaster(mainList[i].id + "|" + GoDataStatus + "|" + TimeStamp);
                            transferred_count = transferred_count + 1;
                        }
                    }
                }
            }
            //Create or append log for every process execution (LimeSurvey_Log.txt)
            Common.LimeSurveyLog(TimeStamp +"|"+ transferred_count);
            return transferred_count.ToString();
            //return Json(new { json_status = transfer_status, json_message = "Total records processed: "+count_success }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetLimeSurveyAPI_ListParticipants()
        {

            bool status = false;
            string message = "";

            string Baseurl = AppSettings.DataFormRemoteControlURL;
            LSJsonRPCclient client = new LSJsonRPCclient(Baseurl);
            client.Method = "get_session_key";
            client.Parameters.Add("username", AppSettings.LimeSurveyUserName);
            client.Parameters.Add("password", AppSettings.LimeSurveyPwd);
            client.Post();
            string SessionKey = client.Response.result.ToString();

            client.ClearParameters();

            if (client.Response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                client.Method = "list_participants";
                client.Parameters.Add("sSessionKey", SessionKey);
                client.Parameters.Add("iSurveyID", AppSettings.LimeSurveyID);
                client.Parameters.Add("iStart", AppSettings.LimeSurvey_iStart);
                client.Parameters.Add("iLimit", AppSettings.LimeSurvey_iLimit);
                client.Parameters.Add("bUnused", string.IsNullOrEmpty(AppSettings.LimeSurvey_bUnused) ? null : AppSettings.LimeSurvey_bUnused);
                client.Parameters.Add("aAttributes", AppSettings.LimeSurvey_aAttributes); //completed,usesleft
                client.Parameters.Add("aConditions", string.IsNullOrEmpty(AppSettings.LimeSurvey_aConditions) ? null : AppSettings.LimeSurvey_aConditions);
                client.Post();

                //##To get participants info by using tid (id from dataform). Not applicable here as we don't have tid
                //client.Method = "get_participant_properties";
                //client.Parameters.Add("sSessionKey", SessionKey);
                //client.Parameters.Add("iSurveyID", AppSettings.LimeSurveyID);
                //client.Parameters.Add("aTokenQueryProperties ", 5); //tid
                //client.Parameters.Add("aTokenProperties ", null);
                //client.Post();
            }

            if (client.Response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                status = true;
            }

            //GetJsonFormat(message, SessionKey);
            //string totalCount = TransferLimeSurveyToGoData(message, SessionKey);

            return Json(new { json_status = status, json_message = "Ok" }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetGoDataAPI()
        {
            //#Get GoData access token
            bool status = true;
            LoginTokenDto model = new LoginTokenDto();
            Common result = new Common();
 
            string Username = AppSettings.GoData_UserName;
            string Password = AppSettings.GoData_Password;
            string BaseURL = AppSettings.GoData_APIUrl;
            string Method_Oauth = "oauth/token?access_token=Token";
            model = result.GetLoginDetails(Username, Password, BaseURL+Method_Oauth);

            result.GET_Outbreaks_ALL(model.access_token);

            return Json(new { json_status = status, json_message = "ok" }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult PostGoDataAPI_FollowUps()
        {
            bool status = true;
            LoginTokenDto model = new LoginTokenDto();
            Common result = new Common();

            string Username = AppSettings.GoData_UserName;
            string Password = AppSettings.GoData_Password;
            string BaseURL = AppSettings.GoData_APIUrl;
            string Method_Oauth = "oauth/token?access_token=Token";
            model = result.GetLoginDetails(Username, Password, BaseURL + Method_Oauth);

            //TODO: to try this out, LS mapping is required to replaced null value below, personId need to hardcode
            //string personId = "3c493744-65ce-40ca-96ca-db4175ae0a8d"; //test personId
            //result.POST_FollowUps(null, personId, model.access_token);

            return Json(new { json_status = status, json_message = "ok" }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}