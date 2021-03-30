import requests
import json

class goData:

    def __init__(self, user = None, password = None, outbreakid = None, base_url = None, proxies = None):
        self.user = user
        self.password = password
        self.outbreak_id = outbreakid
        self.base_url = base_url
        self.proxies = proxies
        self.token = None
        self.response = None
        self.authenticate()
        

    def authenticate(self):
        if self.user:
            oauth_data = {
                "username": self.user,
                "password": self.password
                }

            self.response = requests.post(
                self.base_url + '/oauth/token',    
                data = oauth_data,
                proxies = self.proxies
                )

            self.token = self.response.json()['response']['access_token']

        else:
            return 'Missing Username & Password'
 
    def get_contact(self, foreign_key, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/{foreign_key}/relationships/contacts',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)
    
    def get_contacts(self, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/contacts',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def get_contacts_export(self, filter = None, format = 'csv'):
    
            header = {
            'Authorization': self.token,
            'filter': filter,
            'type': format
            }
            self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/contacts/export',
            headers = header,
            proxies = self.proxies
            )

            return self.response

    def get_case(self, foreign_key, filter = None):
        
        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/{foreign_key}',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def get_cases(self, filter = None):
        
        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def get_case_export(self, filter = r'{"where": {"classification": {"inq": ["LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_CONFIRMED","LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_ANTIBODY_POSITIVE","LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_CONFIRMED","LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_PROBABLE","LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_SUSPECT"]}}}', format = 'csv'):
        
        header = {
        'Authorization': self.token,
        'filter': filter,
        'type': format
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/export/',
            headers = header,
            proxies = self.proxies
        )

        return self.response

    def get_lab(self, foreign_key, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/{foreign_key}/lab-results',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def get_labs(self, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/lab-results',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)


    def get_events(self, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/events',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def get_event(self, foreign_key, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/events{foreign_key}',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def put_case(self, foreign_key, data):

        header = {
            'Authorization': self.token,
        }

        self.response = requests.put(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/{foreign_key}',
            headers = header,
            data = data,
            proxies = self.proxies
        )

        return self.response

    def post_case(self, foreign_key, data):

        header = {
            'Authorization': self.token,
        }

        self.response = requests.post(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases',
            headers = header,
            data = data,
            proxies = self.proxies
        )

        return self.response

    def post_labs(self, foreign_key, data):

        header = {
            'Authorization': self.token,
        }

        self.response = requests.post(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/{foreign_key}/lab-results',
            headers = header,
            data = data,
            proxies = self.proxies
        )

        return self.response

    def generate_visualid(self, data = 'CASE-999999'):

        header = {
            'Authorization': self.token,
        }

        self.response = requests.post(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/cases/generate-visual-id',
            headers = header,
            data = data,
            proxies = self.proxies
        )

        return self.response

    def get_followup(self, foreign_key, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/contacts/{foreign_key}/follow-ups',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def get_followups(self, filter = None):

        header = {
        'Authorization': self.token,
        'filter': filter
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/follow-ups',
            headers = header,
            proxies = self.proxies
        )

        return json.loads(self.response.text)

    def get_followups_export(self, filter = None, format = 'csv'):

        header = {
        'Authorization': self.token,
        'filter': filter,
        'type': format
        }

        self.response = requests.get(
            url = f'{self.base_url}/outbreaks/{self.outbreak_id}/contacts/follow-ups/export',
            headers = header,
            proxies = self.proxies
        )

        return self.response
		
    def get_relationships_export(self, filter = None, format = 'csv'):

        header = {
        'Authorization': self.token,
        'filter': filter,
        'type': format
        }
        
        self.response = requests.get(
        url = f'{self.base_url}/outbreaks/{self.outbreak_id}/relationships/export/',
        headers = header,
        proxies = self.proxies
        )

        return self.response