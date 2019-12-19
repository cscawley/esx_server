import Nui from '../../util/Nui';

export const setSearch = (search) => {
  return dispatch => {
    Nui.send('SearchVehicles', {
      search: search,
    }).then(_ => {
      dispatch({
        type: 'SET_SEARCH',
        payload: search,
      });
    });
  };
};

export const setVehicleImage = (plate, url, search) => {
  Nui.send('SetVehicleImage', {
    plate: plate,
    url: url,
  }).then(_ => {
    Nui.send('SearchVehicles', {
      search: search,
    });
  });
};
export const setSelectedVehicle = (data) => {
  return {
    type: 'SET_SELECTED_VEHICLE',
    payload: data,
  };
};

export const setBolo = (plate, set, currentSearch) => {
  return dispatch => Nui.send('SetBolo', {
    plate: plate,
    bolo: set,
  }).then(_ => {
    dispatch(setSearch(currentSearch));
  });
};
