#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#     Extract case export from Go.Data and upload to SQL Server

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

### Initial imports and setup ###
import requests
import pandas as pd
import numpy as np
import json
import re
import io
from io import BytesIO
from operator import itemgetter 
from pygodata.pygodata import goData
from time import strftime
from datetime import datetime
from sqlalchemy import *
import sys
from dotenv import load_dotenv, find_dotenv
import os
import ast
import logging
from dateutil.relativedelta import relativedelta
import config ## unique config file with environ variables for SQL server

# define functions
def flatten_json(nested_json):
    out = {}

    def flatten(x, name=''):
        if isinstance(x, dict):
            for a in x:
                flatten(x[a], name + a + '_')
        elif isinstance(x, list):
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x

    flatten(nested_json)
    return out

def impute_age(d):
    try:
        d1 = pd.to_datetime(d[1]).date()
        d2 = pd.to_datetime(d[0]).date()
        return relativedelta(d2, d1).years
    except:
        return d[0]

def convert_to_datetime64(x):
    return pd.to_datetime(x,errors='coerce',utc=True)

# initiate logging and configure
try:
    load_dotenv(override = True)
    conf = config(os.environ['xxx'], 'Go.Data Cases ETL', sys.argv) ## ETL env variable

    # Initialize Logging file and object
    timestamp = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    logfilename = f"{conf.env}-{conf.job_type}-{timestamp}.log"
    logfile = os.environ['xxx'] + logfilename ## log file directory variable
    logging.basicConfig(filename=logfile, format="%(asctime)s - %(levelname)s: %(message)s")
    logger = logging.getLogger()
    logger.setLevel(20)

    logger.info('Go.Data Cases ETL')
    logger.info("--------------------------------------------------------------------------------")

    proxies = ast.literal_eval(os.environ['xxx']) ## ETL proxy variable
    go_data_config = ast.literal_eval(os.environ['xxx']) ## ETL GoData variable

except:
    e = sys.exc_info()[0]
    logger.error(e)

# connect to godata
try:
    logger.info('Connecting to Go.Data API')
    gd = goData(
        user = 'xxx',  ## username
        password = 'xxx', ## password
        outbreakid='xxx', ## outbreak id
        base_url= 'xxx', ## host url
        proxies = 'xxx' ## proxies, if any
    )
except:
    e = sys.exc_info()[0]
    logger.error(e)

# import via case export api call, clean up column names
try:
    logger.info('Get Case Export from Go.Data API')
    case_export = gd.get_case_export(format = 'json')

    case_df = pd.DataFrame([flatten_json(item) for item in json.loads(case_export.text)])
    case_df.columns = [re.sub(r'[^\w\s]','',name).replace(' ','_').upper()[:128] for name in case_df.columns]
    duplicate_cols = case_df.columns[case_df.columns.duplicated()].values
    case_df.columns = [name + '_' + str(i) if name in duplicate_cols else name for i, name in enumerate(case_df.columns)] 

    # add timestamp to data set
    case_df['LOAD_DATE'] = pd.to_datetime('today')

except:
    e = sys.exc_info()[0]
    logger.error(e)

# setup connection engine
try:
    logger.info('Connecting to database')
    engine = db(conf, 'xxx') ## destination database and table 
    conn = engine.connect()
except:
    e = sys.exc_info()[0]
    logger.error(e)

# load to database
try:
    logger.info('Load data to database')
    case_df.to_sql('GODATA_CASES', index=False, con=conn, if_exists='replace', chunksize=1000)
except:
    e = sys.exc_info()[0]
    logger.error(e)

logger.info("End Process")
logger.info("================================================================================")
logging.shutdown()

#----------------------------------------------------------------------------------------
# Send email notification
#----------------------------------------------------------------------------------------
sendmail = email(conf)
error = sendmail.check_log_for_string(logfile)
if not error:
    sendmail.send_email_file(logfilename, logfile)
else:
    subject = f'ERROR: {logfilename}'
    message_text = f'Error in log file {logfile}'
    sendmail.send_email_text(subject, message_text)
#---------------------------------------------------------------------------------------