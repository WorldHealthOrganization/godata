using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LSIntegration.Models
{
    public class LoginTokenDto
    {
        public string username { get; set; }
        public string password { get; set; }
        public string access_token { get; set; }
        public string token_type { get; set; }
        public string expires_in { get; set; }
    }

    public class FollowUpsDto
    {
        public DateTime date { get; set; }
        public string statusId { get; set; }
        public List<FollowUpsAddressDto> address { get; set; }
        public string usualPlaceOfResidenceLocationId { get; set; }
        public List<FollowUpsQnADto> questionnaireAnswers{get;set;}
        public int index { get; set; }
        public string teamId { get; set; }
        public string outbreakId { get; set; }
        public bool targeted { get; set; }
        public string comment { get; set; }
        public string deletedByParent { get; set; }
        public List<FollowUpsAddressGeoLocationDto> fillLocation { get; set; }
        public string id { get; set; }
        public DateTime createdAt { get; set; }
        public string createdBy { get; set; }
        public DateTime updatedAt { get; set; }
        public string updatedBy { get; set; }
        public string createdOn { get; set; }
        public bool deleted { get; set; }
        public DateTime deletedAt { get; set; }
        public string personId { get; set; }

    }

    public class FollowUpsAddressDto
    {
        public string typeId { get; set; }
        public string country { get; set; }
        public string city { get; set; }
        public string addressLine1 { get; set; }
        public string postalCode { get; set; }
        public string locationId { get; set; }
        public List<FollowUpsAddressGeoLocationDto> geoLocation { get; set; }
        public bool geoLocationAccurate { get; set; }
        public DateTime date { get; set; }
        public string phoneNumber { get; set; }
        public string emailAddress { get; set; }
    }

    public class FollowUpsAddressGeoLocationDto
    {
        public int lat { get; set; }
        public int lng { get; set; }
    }

    public class FollowUpsQnADto
    {
        public List<FollowUpsQnAValueDto> fever_38_c { get; set; }
        public List<FollowUpsQnAValueDto> respiratory_symptoms { get; set; }
        public List<FollowUpsQnAValueDto> general_symptoms { get; set; }
        public List<FollowUpsQnAValueDto> ent_opthalmic_symptoms { get; set; }
        public List<FollowUpsQnAValueDto> gastrointestinal_symptoms { get; set; }
        public List<FollowUpsQnAValueDto> neurological_symptoms { get; set; }
        public List<FollowUpsQnAValueDto> Temperature_details { get; set; }
        public List<FollowUpsQnAValueDto> other { get; set; }

    }

    public class FollowUpsQnAValueDto
    {
        public string[] value { get; set; }
    }

    public class Respiratory_SymptomsDto
    {
        public string Cough { get; set; }
        public string shortness_of_breath { get; set; }
    }

}