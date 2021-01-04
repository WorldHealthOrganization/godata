// Your job goes here.
alterState(state => {
  const cases = state.HMISCases.map(report => {
    const gender = report.gender.substring(report.gender.lastIndexOf('_') + 1);
    var birthYear = report.age ? report.age.years : report['age:years'];
    birthYear = new Date().getFullYear() - birthYear;
    var telecom =
      report.addresses && report.addresses[0]
        ? report.addresses[0].phoneNumber
        : report['addresses:phoneNumber'];
    telecom = telecom
      ? `${telecom.substring(0, 3)}-${telecom.substring(
          3,
          6
        )}-${telecom.substring(6)}`
      : undefined;
    return {
      name: `${report.firstName} ${report.lastName || ''}`,
      active:
        report.classification ===
        'LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_SUSPECT'
          ? true
          : false,
      externalId: report.id,
      identifier: report.visualId,
      birthDate: `1/1/${birthYear}`,
      telecom,
      address:
        report.addresses && report.addresses[0]
          ? report.addresses[0].country
          : report['addresses:country'],
      locationId:
        report.addresses && report.addresses[0]
          ? report.addresses[0].locationId
          : report['addresses:locationId'],
      gender: gender === 'FEMALE' || gender === 'MALE' ? gender : 'other',
      registrationDate: report.dateOfReporting,
    };
  });

  console.log('Preparing to upsert cases...');
  console.log(cases);
  return upsertMany('tbl_cases', 'identifier', state => cases)(state);
});
