sql(state => 'SELECT * FROM tbl_cases WHERE active = true');
alterState(state => {
  const cases = state.response.body.rows;

  return { ...state, cases };
});
