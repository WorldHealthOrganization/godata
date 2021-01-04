alterState(state => {
  // Replace this endpoint with any of the examples above
  let endpoint = {
    path: '/api/v2/facilities',
    description: 'Returns a list of facilities with some filtering parameters.',
  };

  state['endpoint'] = endpoint;

  // Replace this with a query filter to match the desired results
  let query = {
    'api-key': state.configuration['api-key'],
    country: 'Bangladesh',
    page: 1,
  };

  state.query = query;

  console.log('HealthSites.io Endpoint:\n', state.endpoint);
  console.log('Endpoint Query:', {
    ...state.query,
    'api-key': '********************',
  });
  return state;
})(state);

get(
  `${state.configuration.hostUrl + state.endpoint.path}`,
  {
    query: state.query,
    headers: { 'content-type': 'application/json' },
  },
  function (state) {
    return state;
  }
);

post(
  state.configuration.inboxUrl,
  {
    body: state => {
      let __endpoint = state.endpoint;
      let __query = { ...state.query, 'api-key': '********************' };
      let data = { __endpoint, __query, ...state.data };
      return data;
    },
    headers: { 'content-type': 'application/json' },
  },
  function (state) {
    return state;
  }
);

/** 
 * Example HealthSite Endpoints
 *     
 * 
    {
      "path": "/api/schema/",
      "description": "Schema list"
    },
    {
      "path": "/api/v2/facilities/",
      "description": "Returns a list of facilities with some filtering parameters."
    },
    {
      "path": "/api/v2/facilities/way/454875140",
      "description": "Returns a facility detail."
    },
    {
      "path": "/api/v2/facilities/by-uuid/08e91a3157734f7dbc4ccceade9294be",
      "description": "Get facility by uuid"
    },
    {
      "path": "/api/v2/facilities/count",
      "description": "Returns count of facilities with some filtering parameters."
    },
    {
      "path": "/api/v2/facilities/statistic",
      "description": "Returns statistic of facilities with some filtering parameters."
    }

 */

