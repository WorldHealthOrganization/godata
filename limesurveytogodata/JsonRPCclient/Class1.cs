using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Net;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace JsonRPCclient
{
    public class LSJsonRPCclient
    {
        private int id = 0;
        /// <summary>
        /// Set JSON-RPC webservice URL
        /// </summary>
        public string URL { set; get; }
        /// <summary>
        /// Set JSON-RPC method
        /// </summary>
        public string Method { set; get; }
        /// <summary>
        /// Add JSON-RPC params
        /// </summary>
        public JObject Parameters { set; get; }

        /// <summary>
        /// Results of the request
        /// </summary>
        public JsonRPCresponse Response { set; get; }


        /// <summary>
        /// Create a new object of RPCclient 
        /// </summary>
        public LSJsonRPCclient()
        {
            Parameters = new JObject();
            Response = null;
        }

        /// <summary>
        /// Create a new object of RPCclient
        /// </summary>
        /// <param name="URL"></param>
        public LSJsonRPCclient(string URL)
        {
            this.URL = URL;
            Parameters = new JObject();
            Response = null;
        }

        /// <summary>
        /// POST the request and returns server response
        /// </summary>
        /// <returns></returns>
        public string Post()
        {
            try
            {
                JObject jobject = new JObject();
                jobject.Add(new JProperty("jsonrpc", "2.0"));
                jobject.Add(new JProperty("id", ++id));
                jobject.Add(new JProperty("method", Method));
                jobject.Add(new JProperty("params", Parameters));

                string PostData = JsonConvert.SerializeObject(jobject);
                UTF8Encoding encoding = new UTF8Encoding();
                byte[] bytes = encoding.GetBytes(PostData);

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
                request.Method = "POST";
                request.ContentType = "application/json";
                request.KeepAlive = true;
                request.ContentLength = bytes.Length;

                Stream writeStream = request.GetRequestStream();
                writeStream.Write(bytes, 0, bytes.Length);
                writeStream.Close();

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                Stream responseStream = response.GetResponseStream();
                StreamReader readStream = new StreamReader(responseStream, Encoding.UTF8);

                Response = new JsonRPCresponse();
                Response = JsonConvert.DeserializeObject<JsonRPCresponse>(readStream.ReadToEnd());
                Response.StatusCode = response.StatusCode;

                return Response.ToString();
            }
            catch (Exception e)
            {
                return e.ToString();
            }
        }

        public void ClearParameters()
        {
            this.Parameters = new JObject();
        }
    }

    public class JsonRPCresponse
    {
        public int id { set; get; }
        public object result { set; get; }
        public string error { set; get; }
        public HttpStatusCode StatusCode { set; get; }

        public JsonRPCresponse() { }

        public override string ToString()
        {
            return "{\"id\":" + id.ToString() + ",\"result\":\"" + result.ToString() + "\",\"error\":" + error + ((String.IsNullOrEmpty(error)) ? "null" : "\"" + error + "\"") + "}";
        }
    }

}
