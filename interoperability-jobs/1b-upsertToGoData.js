each(
  '$.cases[*]',
  alterState(state => {
    const report = state.data;
    console.log(new Date().getFullYear());

    const data = {
      firstName: report.name.split(' ')[0],
      lastName: report.name.split(' ')[1],
      classification:
        report.active == true
          ? 'LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_SUSPECT'
          : '',
      id: report.externalid,
      visualId: report.identifier,
      age: {
        years:
          new Date().getFullYear() - parseInt(report.birthdate.substring(0, 4)),
      },
      addresses: [
        {
          typeId:
            'LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_USUAL_PLACE_OF_RESIDENCE',
          country: report.address,
          locationId: report.locationid,
        },
      ],
      gender: report.gender,
      dateOfReporting: report.registrationdate,
    };

    console.log(`Upsert case for ${data.firstName}`);
    console.log(data);

    return upsertCase(
      '3b5554d7-2c19-41d0-b9af-475ad25a382b', // the outbreak ID
      'visualId',
      { data }
    )(state);
  })
);
