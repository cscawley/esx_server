export const initialState = {
  vehicles: [],
  currentSearch: '',
  selected: null,
  selectedImage: '',
};

const reducer = (state = initialState, action) => {

  switch (action.type) {
    case 'SET_VEHICLES':
      return {
        ...state,
        vehicles: action.payload.vehicles,
      };
    case 'SET_SEARCH':
      return {
        ...state,
        currentSearch: action.payload,
      };
    case 'SET_SELECTED_VEHICLE': {
      return {
        ...state,
        selected: action.payload,
        selectedImage: action.payload !== null ? action.payload.vehicleimage : '',
      };
    }
    default: {
      return state;
    }
  }
};

export default reducer;
