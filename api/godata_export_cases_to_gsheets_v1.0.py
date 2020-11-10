# Read Go.Data Cases, clean, aggregate and export to Google Sheets
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

apiurl  = ''          # url of the API, ends with '/'
login   = ''          # go.data email login
passw   = ''          # go.data password
OID     = ''          # outbreak ID
creds   = r'''{}'''   # credentials for google sheets api
sheetid = ''          # the ID of your google sheet
# last step is to share the sheet with email from creds.client_email, as Editor



### DEPENDENCIES ==================================

import requests
import pandas as pd
import gspread
import time


print('>>>>>>>>>>>>>>>>>>>>>> START')
start = time.time()

### IMPORT DATA ==================================

## GET TOKEN -----
query = 'oauth/token'
PARAMS = {'username':login, 'password': passw}
r = requests.post(url = apiurl+query, data = PARAMS) 
data = r.json()
token = data['access_token']

## OUTBREAK ID -----
print('outbreak: ' +OID)

## GET RAW CASES DATA -----
query = 'outbreaks/'+OID
query += '/cases/export' # all the cases
query += '?access_token='+ token
r = requests.get(url = apiurl+query)
data = r.json()
df1 = pd.json_normalize(data) # json to df

print( 'shape raw data: ' + ' x '.join(str(i) for i in df1.shape) )


### CLEAN DATA ==================================

## SELECT + RENAME + RECODE -----
df = df1[['Date of reporting','Classification','Gender','Age.Age / Years', 'Addresses']].copy()
df.rename(columns={'Date of reporting': 'Date', 
                'Classification': 'Classification', 
                'Gender': 'Gender', 
                'Age.Age / Years': 'Age', 
                'Addresses': 'PlaceOfResidence'
                }, inplace=True)
df['Gender'] = (df['Gender']
                .replace('', 'UNK')
                .replace('Male', 'M')
                .replace('Female', 'F'))
df['Classification'] = (df['Classification']
                .replace('Confirmed (asymptomatic)', 'Confirmed')
                .replace('Not a case (discarded)', 'Discarded')
                )

## EXTRACT PlaceOfResidence -----
df_add = pd.json_normalize(df.to_dict('list'), ['PlaceOfResidence']).unstack().apply(pd.Series)
df = df.join(df_add[['Location']].reset_index())
df.drop(columns=['PlaceOfResidence', 'level_0','level_1'], inplace=True)
df.rename(columns={'Location': 'PlaceOfResidence'}, inplace=True)
df['PlaceOfResidence'] = df['PlaceOfResidence'].str.strip()

## ADD CASES -----
df['Cases'] = 1

## AGEGROUPS -----
bins = [0,5,10,20,30,40,50,60,70,150]
labels = ['00-05','05-10','10-20','20-30','30-40','40-50','50-60','60-70','70-++']
df['AgeGroup'] = pd.cut(df['Age'], bins=bins, labels=labels, right=False)

## AGGREGATE -----
aggby = ['Date','Gender','AgeGroup','PlaceOfResidence','Classification']
df_agg = df.groupby(aggby)['Cases'].sum().reset_index()

## DROP NAN LINES -----
df_agg = df_agg[df_agg['Cases'].notna()].reset_index(drop=1)

## FORMAT DATE -----
df_agg['Date'] = df_agg['Date'].astype('datetime64[ns]')
df_agg['Date'] = df_agg['Date'].astype(str)

print( 'shape aggregated: ' + ' x '.join(str(i) for i in df_agg.shape) )


### EXPORT TO SHEETS ==================================

## WRITE CREDENDTIALS TO FILE -----
file = open('service_account.json','w') 
file.write(creds) 
file.close()

## CONNECT SHEETS API -----
gc = gspread.service_account(filename='service_account.json')
sht = gc.open_by_key(sheetid)
worksheet = sht.worksheet("cases")

## CLEANUP SHEET -----
rows = df_agg.shape[0]
cell_list = worksheet.range('A1:F'+str(rows*2)) # remove double the rows
for cell in cell_list:
    cell.value = ''
worksheet.update_cells(cell_list)

## INSERT DF -----
worksheet.update([df_agg.columns.values.tolist()] + df_agg.values.tolist())

## INSERT LAST UPATE -----
timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
worksheet = sht.worksheet("meta")
worksheet.update('A2', timestamp)


### TERMINATE ==================================
print('timestamp: ', timestamp)
end = time.time()
print('elapsed: ' + str(round(end - start)) + 's')
print('<<<<<<<<<<<<<<<<<<<<<< END')