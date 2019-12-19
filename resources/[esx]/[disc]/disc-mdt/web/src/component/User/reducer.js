export const initialState = {
  user: {},
  darkMode: true,
  location: {
    area: '',
    street: '',
    coords: {},
  },
  datetime: {
    time: '',
    date: ''
  },
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case 'SET_USER':
      return {
        ...state,
        user: action.payload.user,
        darkMode: action.payload.user.darkmode,
      };
    case 'SET_DARKMODE' : {
      return {
        ...state,
        darkMode: action.payload,
      };
    }
    case 'SET_LOCATION' : {
      return {
        ...state,
        location: action.payload.location,
      };
    }
    case 'SET_TIME' : {
      return {
        ...state,
        datetime: action.payload.datetime,
      };
    }
    default: {
      return state;
    }
  }
};

export default reducer;
