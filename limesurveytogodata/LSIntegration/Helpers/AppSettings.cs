using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System;
using System.Configuration;

namespace LSIntegration.Helpers
{
    public class AppSettings
    {
        public static string LogFolder
        {
            get
            {
                return ConfigurationManager.AppSettings["LogFolder"].ToString();
            }
        }

        public static string DataFormRemoteControlURL
        {
            get
            {
                return ConfigurationManager.AppSettings["DataForm.RemoteControlURL"].ToString();
            }
        }

        public static string LimeSurveyUserName
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.UserName"].ToString();
            }
        }
        public static string LimeSurveyPwd
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.Password"].ToString();
            }
        }
        public static string LimeSurveyID
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.Id"].ToString();
            }
        }

        public static string LimeSurvey_sDocumentType
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.sDocumentType"].ToString();
            }
        }

        public static string LimeSurvey_sLanguageCode
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.sLanguageCode"].ToString();
            }
        }

        public static string LimeSurvey_sCompletionStatus
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.sCompletionStatus"].ToString();
            }
        }

        public static string LimeSurvey_sHeadingType
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.sHeadingType"].ToString();
            }
        }

        public static string LimeSurvey_sResponseType
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.sResponseType"].ToString();
            }
        }

        public static string LimeSurvey_iFromResponseID
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.iFromResponseID"].ToString();
            }
        }

        public static string LimeSurvey_iToResponseID
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.iToResponseID"].ToString();
            }
        }

        public static string GoData_UserName
        {
            get
            {
                return ConfigurationManager.AppSettings["GoData.Username"].ToString();
            }
        }

        public static string GoData_Password
        {
            get
            {
                return ConfigurationManager.AppSettings["GoData.Password"].ToString();
            }
        }

        public static string GoData_APIUrl
        {
            get
            {
                return ConfigurationManager.AppSettings["GoData.APIUrl"].ToString();
            }
        }

        public static string GoData_OutbreakID
        {
            get
            {
                return ConfigurationManager.AppSettings["GoData.OutbreakID"].ToString();
            }
        }

        public static string LimeSurvey_iStart
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.iStart"].ToString();
            }
        }

        public static string LimeSurvey_iLimit
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.iLimit"].ToString();
            }
        }

        public static string LimeSurvey_bUnused
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.bUnused"].ToString();
            }
        }

        public static string LimeSurvey_aAttributes
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.aAttributes"].ToString();
            }
        }

        public static string LimeSurvey_aConditions
        {
            get
            {
                return ConfigurationManager.AppSettings["LimeSurvey.aConditions"].ToString();
            }
        }
    }
}