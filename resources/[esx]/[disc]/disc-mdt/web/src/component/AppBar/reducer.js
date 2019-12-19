import { useSelector } from 'react-redux';

export const initialState = {
  notifications: [],
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case 'ADD_NOTIFICATION':
      return {
        ...state,
        notifications: [...state.notifications, action.payload],
      };
    case 'REMOVE_NOTIFICATION':
      return {
        ...state,
        notifications: [...state.notifications.filter((key, index) => index !== action.payload.index)],
      };
    case 'CLEAR_NOTIFICATIONS':
      return initialState;
    default:
      return state;
  }

};

export default reducer;
