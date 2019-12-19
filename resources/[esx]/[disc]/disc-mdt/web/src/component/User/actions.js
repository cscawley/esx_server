import Nui from '../../util/Nui';

export const setDarkMode = (identifier, dark) => {
  return dispatch => {
    Nui.send('SetDarkMode', {
      identifier: identifier,
      state: dark,
    }).then(_ => {
      dispatch({
        type: 'SET_DARKMODE',
        payload: dark,
      });
    });
  };
};

export const getLocation = () => {
  Nui.send('GetLocation');
};

export const getTime = () => {
  const date = new Date();
  return {
    type: 'SET_TIME',
    payload: {
      datetime: {
        time: doubleNumber(date.getHours()) + ':' + doubleNumber(date.getMinutes()),
        date: date.getFullYear() + '-' + doubleNumber((date.getMonth() + 1)) + '-' + doubleNumber(date.getDate()),
      },
    },
  };
};

const doubleNumber = (number) => number < 10 ? '0' + number : number;
