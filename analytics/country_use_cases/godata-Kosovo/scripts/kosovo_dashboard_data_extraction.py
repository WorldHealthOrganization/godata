# Read Go.Data Cases, clean, filter, aggregate and export to Google Sheets
# Copyright (C) 2020  Mathias Leroy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


__author__ = "Mathias Leroy"
__copyright__ = "Copyright (C) 2020  Mathias Leroy"
__license__ = "GNU General Public License"
__version__ = "1.0"


### PARAMETERS ================================== (to be modified before use)

apiurl  = ''          # (required) url of the API, ends with '/api/' 
login   = ''          # (required) go.data email login
passw   = ''          # (required) go.data password
OID     = ''          # (optional) outbreak ID, if empty will take 1st outbreak
creds   = r'''{}'''   # credentials for google sheets api. cf. https://gspread.readthedocs.io/en/latest/oauth2.html#for-bots-using-service-account
                      # in AWS lambda: leave this empty and create a file service_account.json with the object
sheetid = ''          # the ID of your google sheet to be written in (found in the url of the sheet)


### DEPENDENCIES ==================================

###################################
## How to install libraries on windows, after installing python 3.9 (in cmd without admin rights)
# python -m pip install requests
# python -m pip install pandas
# python -m pip install gspread
# python -m pip install time
# python -m pip install numpy
# python -m pip install datetime
###################################

import requests
import pandas as pd
import gspread
import time
import numpy as np
from datetime import datetime

print('>>>>>>>>>>>>>>>>>>>>>> START')
start = time.time()
timestamp = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()+ 60*60))



### IMPORT DATA ==================================

## GET TOKEN -----
query = 'oauth/token'
PARAMS = {'username':login, 'password': passw}
r = requests.post(url = apiurl+query, data = PARAMS) 
data = r.json()
if 'access_token' in data: token = data['access_token']
elif 'response' in data: token = data['response']['access_token']
print('token: ' +token)
print('t: get token: ' + str(round(time.time() - start)) + 's')

## OUTBREAK ID -----
global OID
if OID=='': 
  query = 'outbreaks?access_token='+ token
  r = requests.get(url = apiurl+query)
  outbreak = r.json()[0] # use the first one
  # print(r.json()) # if several outbreaks -> find the right id here
  OID = outbreak['id']
  print('outbreak id: ' +OID)
  print('t: elapsed: ' + str(round(time.time() - start)) + 's')

## GET RAW CASES DATA -----
query = 'outbreaks/'+OID
query += '/cases/export' # all the cases
query += '?access_token='+ token
r = requests.get(url = apiurl+query)
data = r.json()
df1 = pd.json_normalize(data) # json to df
print('t: get raw cases data: ' + str(round(time.time() - start)) + 's') # 16s
print( 'shape raw data: ' + ' x '.join(str(i) for i in df1.shape) )



### CLEAN DATA ==================================

## SELECT RENAME RECODE -----
df = df1[['Classification', 'Gender','Age.Age / Years', 'Addresses', 'Outcome', 
          'Date of reporting', 'Created at', 'Date of outcome', 'Date of becoming case']].copy()

df.rename(columns={'Gender': 'Gender', 
                   'Date of reporting': 'DateOfReporting', 
                   'Created at': 'DateOfCreation',
                   'Date of outcome': 'DateOfOutcome', 
                   'Date of becoming case': 'DateOfBecomingAcase', 
                   'Classification': 'Classification', 
                   'Age.Age / Years': 'Age' ,
                   }, inplace=True)
df['Gender'] = (df['Gender']
                .replace('', 'UNK')
                .replace('Male', 'M')
                .replace('Female', 'F'))
df['Classification'] = (df['Classification']
                .replace('Confirmed (asymptomatic)', 'Confirmed')
                .replace('Not a case (discarded)', 'Discarded'))

## error date - need to find a way to generalize this
df.loc[df['DateOfReporting'] == '0002-01-16T00:00:00.000Z', 'DateOfReporting'] = '2020-01-16T00:00:00.000Z'
df['DateOfCreation'] = pd.to_datetime(df['DateOfCreation']).dt.date # remove the time
df['DateOfReporting'] = pd.to_datetime(df['DateOfReporting']).dt.date
df['DateOfOutcome'] = pd.to_datetime(df['DateOfOutcome']).dt.date
df['DateOfBecomingAcase'] = pd.to_datetime(df['DateOfBecomingAcase']).dt.date
print('t: select rename recode: ' + str(round(time.time() - start)) + 's')

## FILTER -----
## IMPOSSIBLE VALUES 
df.loc[df['DateOfCreation'] < pd.to_datetime('2020-02-01').date(), 'DateOfCreation'] = pd.NaT
df.loc[df['DateOfReporting'] < pd.to_datetime('2020-02-01').date(), 'DateOfReporting'] = pd.NaT
df.loc[df['DateOfOutcome'] < pd.to_datetime('2020-02-01').date(), 'DateOfOutcome'] = pd.NaT
df.loc[df['Age']>100] = np.NaN # requires numpy just for this
## CONFIRMED ONLY
df = df[df.Classification=='Confirmed']
df = df.reset_index(drop=1)
df.drop(columns=['Classification'], inplace=True)

## OUTCOME CORRECTIONS -----
df.loc[(datetime.now().date() - df['DateOfReporting'] > pd.Timedelta(14,'D')) & (df['Outcome'] == 'Alive'), 'Outcome'] = 'Recovered'
df.loc[df['Outcome'] == 'Alive', 'Outcome'] = 'Active'
# checks: df[['DateOfOutcome','Outcome']].sample(60).sort_values(by='DateOfOutcome').head(30)

## ADD PROPERTIES -----
df['Cases'] = 1
df['Date'] = df.DateOfReporting
# df['Week'] = df.Date.dt.week
print('t: filter: ' + str(round(time.time() - start)) + 's')

## EXTRACT ADMIN LEVELS -----
df_por = pd.json_normalize(df.to_dict('list'), ['Addresses']).unstack().apply(pd.Series)
df_por['Municipality'] = [k[1] if isinstance(k,list) and len(k)>0  else 'UNK' for k in df_por['Location Parent location']] # extract 2nd element
df = df.join(df_por[['Location','Municipality']].reset_index())
df.drop(columns=['Addresses', 'level_0','level_1'], inplace=True) # remove the old variables
df.rename(columns={'Location': 'Village'}, inplace=True)
df['Village'] = df['Village'].str.strip()
df['Municipality'] = df['Municipality'].str.strip('(komuna)').str.strip()
print('t: extract place of residence: ' + str(round(time.time() - start)) + 's')

## AGEGROUPS -----
bins = [0,10,20,30,40,50,60,70,80,999]
labels = ['00–09','10–19','20–29','30–39','40–49','50–59','60–69','70–79','80–++']  
df['AgeGroup'] = pd.cut(df['Age'], bins=bins, labels=labels, right=False)
df['AgeGroup'] = df['AgeGroup'].cat.add_categories('NA').fillna('NA') # add NA category, check: df[df.Age.isna()][['Age','AgeGroup']]
print('t: agegroups: ' + str(round(time.time() - start)) + 's')
print( 'shape cleaned data: ' + ' x '.join(str(i) for i in df.shape) )

## AGGREGATE -----
aggregateBy = ['Date','Gender','AgeGroup','Municipality','Outcome'] #,'Classification' ,'Village'
df_agg = df.groupby(aggregateBy)['Cases'].sum().reset_index()

## DROP NAN LINES -----
df_agg = df_agg[df_agg['Cases'].notna()].reset_index(drop=1)

## FORMAT DATE -----
# df_agg['Date'] = df_agg['Date'].astype('datetime64[ns]')
df_agg['Date'] = df_agg['Date'].astype(str)

print('t: aggregate: ' + str(round(time.time() - start)) + 's')
print( 'shape aggregated: ' + ' x '.join(str(i) for i in df_agg.shape) )


# ### EXPORT TO CSV ==================================         uncomment this section to export to csv file
# df_agg.Cases = df_agg.Cases.astype(int)
# df_agg.to_csv('cases.csv', index=False)
# !head -n 10 cases.csv


### EXPORT TO SHEETS ==================================

## WRITE CREDENDTIALS TO FILE -----
if creds:
  file = open('service_account.json','w') 
  file.write(creds) 
  file.close()

## CONNECT SHEETS API -----
gc = gspread.service_account(filename='service_account.json')
sht = gc.open_by_key(sheetid)
worksheet = sht.worksheet("cases")

## EXPORT CASES -----
nrows = df_agg.shape[0]
cell_list = worksheet.range('A1:F'+str(nrows*2)) # remove double the nrows
for cell in cell_list:
    cell.value = ''
worksheet.update_cells(cell_list)

## INSERT DF -----
worksheet.update([df_agg.columns.values.tolist()] + df_agg.values.tolist())

## EXPORT LASTUPDATE -----
elapsed = round(time.time() - start)
totalcases = df_agg.Cases.sum()
worksheet = sht.worksheet('meta')
worksheet.update('A1', 'LastUpdate')
worksheet.update('B1', 'Elapsed')
worksheet.update('C1', 'Cases')
worksheet.update('D1', 'Length')
worksheet.update('A2', timestamp)
worksheet.update('B2', elapsed)
worksheet.update('C2', totalcases)
worksheet.update('D2', nrows)

## EXPORT LOG -----
worksheet = sht.worksheet('log')
nlines = len(worksheet.col_values(1))
worksheet.update_cell(1,1, 'Timestamp')
worksheet.update_cell(1,2, 'Duration')
worksheet.update_cell(1,3, 'TotalCases')
worksheet.update_cell(1,4, 'nRows')
worksheet.update_cell(1,5, 'Display')
worksheet.update_cell(nlines+1, 1, timestamp)
worksheet.update_cell(nlines+1, 2, elapsed)
worksheet.update_cell(nlines+1, 3, totalcases)
worksheet.update_cell(nlines+1, 4, nrows)

print('t: export: ' + str(round(time.time() - start)) + 's')



### AGGREGATE VALUES BY DateOfOutcome/DateOfBecomingAcase, Gender, AgeGroup, Municipality ==================================
by_deaths = ['DateOfOutcome', 'Gender', 'AgeGroup', 'Municipality']
by_recov = ['DateOfOutcome', 'Gender', 'AgeGroup', 'Municipality']
by_cases = ['DateOfBecomingAcase', 'Gender', 'AgeGroup', 'Municipality']

## AGGREGATE CASES -----
df_cases = df.groupby(by_cases)['Cases'].sum().to_frame('NewCases').reset_index()
df_cases = df_cases[df_cases['NewCases'].notna()] # drop NAN
df_cases.rename(columns={'DateOfBecomingAcase': 'Date'}, inplace=True) # rename Date

## AGGREGATE DEATHS -----
df_deaths = df[df.Outcome=='Deceased'].groupby(by_deaths)['Cases'].sum().to_frame('NewDeaths').reset_index()
df_deaths = df_deaths[df_deaths['NewDeaths'].notna()] # drop NAN
df_deaths.rename(columns={'DateOfOutcome': 'Date'}, inplace=True) # rename Date

## AGGREGATE RECOVERED -----
df_recov = df[df.Outcome=='Recovered'].groupby(by_recov)['Cases'].sum().to_frame('NewRecovered').reset_index()
df_recov = df_recov[df_recov['NewRecovered'].notna()] # drop NAN
df_recov.rename(columns={'DateOfOutcome': 'Date'}, inplace=True) # rename Date

## MERGE -----
df_agg2 = pd.merge(df_cases, df_deaths, how='outer')
df_agg2 = pd.merge(df_agg2, df_recov, how='outer')

## CONVERT NAN TO ZERO & DATE TO STRING -----
df_agg2['Date'] = df_agg2['Date'].astype(str)
df_agg2['NewCases'] = df_agg2['NewCases'].fillna(0).astype(int)
df_agg2['NewDeaths'] = df_agg2['NewDeaths'].fillna(0).astype(int)
df_agg2['NewRecovered'] = df_agg2['NewRecovered'].fillna(0).astype(int)

print('t: aggregate 2: ' + str(round(time.time() - start)) + 's')
print( 'shape aggregated: ' + ' x '.join(str(i) for i in df_agg2.shape) )

## EXPORT -----
worksheet = sht.worksheet("daily")
cell_list = worksheet.range('A1:G'+str(df_agg2.shape[0]*2)) # remove double the nrows
for cell in cell_list:
    cell.value = ''
worksheet.update_cells(cell_list)
worksheet.update([df_agg2.columns.values.tolist()] + df_agg2.values.tolist())

print('t: export 2: ' + str(round(time.time() - start)) + 's')



## TERMINATE ==================================
print('timestamp: ', timestamp)
print('t: elapsed: ' + str(round(time.time() - start)) + 's')
print('<<<<<<<<<<<<<<<<<<<<<< END')
