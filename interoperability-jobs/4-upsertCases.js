// Upsert cases from GoData based on Case Id

alterState(state => {
  const patient = state.data.body;

  const data = {
    firstName: patient.Patient_name.split(' ')[0],
    lastName: patient.Patient_name.split(' ')[1],
    classification: 'LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_SUSPECT',
    visualId: patient.Godata_ID,
    'age:years': patient.Age_in_year,
    'addresses:country': 'Argentina',
    'addresses:city': patient['patient_address/Upazilla'],
    gender: patient.Sex,
    dateOfReporting: patient.Date,
  };

  console.log(`Upsert case for ${data.firstName}`);
  console.log(data);

  return upsertCase(
    '3b5554d7-2c19-41d0-b9af-475ad25a382b', // the outbreak ID
    'visualId',
    { data }
  )(state);
});
