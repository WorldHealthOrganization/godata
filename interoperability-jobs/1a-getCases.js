//Job to fetch Cases to sync to other system

// Fetch cases from Go.Data matching a specific outbreak id
listCases('3b5554d7-2c19-41d0-b9af-475ad25a382b', {}, state => {
  function yesterdayDate() {
    const date = new Date();
    date.setDate(date.getDate() - 1);
    date.setHours(0, 0, 0, 0);
    return date.toISOString();
  }

  // set to null if we want to use manualCursor.
  // set to yesterDayDate() to use the date of yesterday.
  const yesterday = null;
  const manualCursor = '2020-07-24T00:00:00.000Z';

  const cases = state.data
    .filter(report => {
      return report.dateOfReporting === (yesterday || manualCursor);
    })
    .map(report => {
      return {
        name: `${report.firstName}, ${report.lastName || ''}`,
        status: report.classification,
        externalId: report.id,
        caseId: report.visualId,
        age: report.age ? report.age.years : report['age:years'],
        phone:
          report.addresses && report.addresses[0]
            ? report.addresses[0].phoneNumber
            : report['addresses:phoneNumber'],
        country:
          report.addresses && report.addresses[0]
            ? report.addresses[0].country
            : report['addresses:country'],
        location:
          report.addresses && report.addresses[0]
            ? report.addresses[0].locationId
            : report['addresses:locationId'],
      };
    });

  const HMISCases = state.data.filter(report => {
    return report.dateOfReporting === (yesterday || manualCursor);
  });

  console.log('Cases received...');
  console.log(cases);
  return { ...state, cases, HMISCases };
});

// Bulk post to OpenFn Inbox
alterState(state => {
  const { openfnInboxUrl } = state.configuration;
  const data = state.cases;
  console.log(`Sending to OpenFn Inbox in bulk...`);
  return axios({
    method: 'POST',
    url: 'https://www.openfn.org/inbox/8775c5e5-72c2-4524-b2ba-e422510ba115', //`${openfnInboxUrl}`,
    data,
  }).then(response => {
    return state;
  });
});
