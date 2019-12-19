export const initialState = {
  jailReport: {
    arrestingOfficer: "",
    identifier: "",
  },
};

const reducer = (state = initialState, action) => {
  if (action.type === 'SET_JAIL_REPORT') {
    return {
      ...state,
      jailReport: action.payload.jailReport
    }
  } else {
    return state;
  }
};

export default reducer;
