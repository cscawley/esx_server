export const initialState = {
  crimes: [],
};

const reducer = (state = initialState, action) => {
  if (action.type === 'SET_CRIMES') {
    return {
      ...state,
      crimes: action.payload.crimes
    }
  } else {
    return state;
  }
};

export default reducer;
