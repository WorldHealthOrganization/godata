//Job to fetch Cases to sync to other system

// Fetch cases from Go.Data matching a specific outbreak id
getCase(
  '3b5554d7-2c19-41d0-b9af-475ad25a382b',
  {
    where: {
      classification:
        'LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_CONFIRMED',
    },
  },
  {},
  state => {
    console.log(`Previous cursor: ${state.lastDateOfReporting}`);
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

    function is24(date) {
      // check if a given date fits in last 24 hours
      const date1 = new Date(date);
      const timeStamp = Math.round(new Date().getTime() / 1000);
      const timeStampYesterday = timeStamp - 24 * 3600;
      return date1 >= new Date(timeStampYesterday * 1000).getTime();
    }

    const currentCases = state.data.filter(report => {
      return report.dateOfReporting === (yesterday || manualCursor);
    });

    const lastDateOfReporting = currentCases
      .filter(item => item.dateOfReporting)
      .map(s => s.dateOfReporting)
      .sort((a, b) => new Date(b) - new Date(a))[0];

    console.log('last day of reporting:', lastDateOfReporting);

    const summary = {
      dateOfReporting: lastDateOfReporting,
      value: currentCases.length,
    };
    console.log('summary', summary);

    return { ...state, currentCases, lastDateOfReporting, summary };
  }
);
