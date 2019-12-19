export const initialState = {
  civilians: [],
  currentSearch: '',
  selected : null,
  selectedImage: "",
  reports: []
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case 'SET_CIVILIANS':
      return {
        ...state,
        civilians: action.payload.civilians,
      };
    case 'SET_CIVILIAN_REPORTS':
      return {
        ...state,
        reports: action.payload.reports,
      };
    case 'SET_CIV_SEARCH' : {
      return {
        ...state,
        currentSearch: action.payload,
      };
    }
    case 'SET_SELECTED_CIVILIAN': {
      return {
        ...state,
        selected: action.payload,
        selectedImage: action.payload !== null ? action.payload.userimage : ""
      };
    }
    default:
      return state;
  }

};

export default reducer;
