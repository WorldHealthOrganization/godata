using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using LSIntegration.Controllers;
using LSIntegration.Helpers;
using System.Web.Mvc;
using System.Configuration;

namespace WindowApp
{
    public partial class LSIntegration : Form
    {
        public LSIntegration()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            HomeController LSController = new HomeController();
            LSController.GetLimeSurveyAPI();
            //string strDir = ConfigurationManager.AppSettings["LogFolder"];
            //string strLogFile = "LimeSurvey_Master.txt";
            //MessageBox.Show("Completed:");
            Application.Exit();
        }
    }
}
