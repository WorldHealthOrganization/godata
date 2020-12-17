using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace LSIntegration.Models
{

    public class LimeSurveyDto
    {
        //public string responses { get; set; }
        public string id { get; set; }
        public string submitdate { get; set; } //DateTime?
        public string lastpage { get; set; }
        public string startlanguage { get; set; }
        public string seed { get; set; }
        public string token { get; set; }
        public string startdate { get; set; } //DateTime?
        public string datestamp { get; set; } //DateTime?
        public string CurrentTemp { get; set; }
        [JsonProperty("HaveTemp[SQ001]")]
        public object HaveTempSQ001 { get; set; }
        [JsonProperty("CurrentRespSymptoms[001]")]
        public string CurrentRespSymptoms001 { get; set; }
        [JsonProperty("CurrentRespSymptoms[002]")]
        public string CurrentRespSymptoms002 { get; set; }
        [JsonProperty("CurrentRespSymptoms[003]")]
        public string CurrentRespSymptoms003 { get; set; }
        [JsonProperty("CurrentGenSymptoms[001]")]
        public string CurrentGenSymptoms001 { get; set; }
        [JsonProperty("CurrentGenSymptoms[002]")]
        public string CurrentGenSymptoms002 { get; set; }
        [JsonProperty("CurrentGenSymptoms[003]")]
        public string CurrentGenSymptoms003 { get; set; }
        [JsonProperty("CurrentGenSymptoms[004]")]
        public string CurrentGenSymptoms004 { get; set; }
        [JsonProperty("CurrentGenSymptoms[005]")]
        public string CurrentGenSymptoms005 { get; set; }
        [JsonProperty("CurrentGenSymptoms[006]")]
        public string CurrentGenSymptoms006 { get; set; }
        [JsonProperty("CurrentGenSymptoms[007]")]
        public string CurrentGenSymptoms007 { get; set; }
        [JsonProperty("CurrentGenSymptoms[008]")]
        public string CurrentGenSymptoms008 { get; set; }
        [JsonProperty("CurrentENTSymptoms[001]")]
        public string CurrentENTSymptoms001 { get; set; }
        [JsonProperty("CurrentENTSymptoms[002]")]
        public string CurrentENTSymptoms002 { get; set; }
        [JsonProperty("CurrentENTSymptoms[003]")]
        public string CurrentENTSymptoms003 { get; set; }
        [JsonProperty("CurrentENTSymptoms[004]")]
        public string CurrentENTSymptoms004 { get; set; }
        [JsonProperty("CurrentENTSymptoms[005]")]
        public string CurrentENTSymptoms005 { get; set; }
        [JsonProperty("CurrentENTSymptoms[006]")]
        public string CurrentENTSymptoms006 { get; set; }
        [JsonProperty("CurrentENTSymptoms[007]")]
        public string CurrentENTSymptoms007 { get; set; }
        [JsonProperty("CurrentGastrSymptoms[001]")]
        public string CurrentGastrSymptoms001 { get; set; }
        [JsonProperty("CurrentGastrSymptoms[002]")]
        public string CurrentGastrSymptoms002 { get; set; }
        [JsonProperty("CurrentGastrSymptoms[003]")]
        public string CurrentGastrSymptoms003 { get; set; }
        [JsonProperty("CurrentGastrSymptoms[004]")]
        public string CurrentGastrSymptoms004 { get; set; }
        [JsonProperty("CurrentGastrSymptoms[005]")]
        public string CurrentGastrSymptoms005 { get; set; }
        [JsonProperty("CurrentNeuroSymptoms[001]")]
        public string CurrentNeuroSymptoms001 { get; set; }
        [JsonProperty("CurrentNeuroSymptoms[002]")]
        public string CurrentNeuroSymptoms002 { get; set; }
        [JsonProperty("CurrentNeuroSymptoms[003]")]
        public string CurrentNeuroSymptoms003 { get; set; }
        public string OtherSymptoms { get; set; }

    }

    public class ListParticipantsDto
    {
        public string tid { get; set; }
        public string token { get; set; }
        public participant_infoDto participant_info { get; set; }
        //public List<participant_infoDto> participant_info { get; set; }
    }

    public class participant_infoDto
    {
        public string firstname { get; set; }
        public string lastname { get; set; }
        public string email { get; set; }
    }

}