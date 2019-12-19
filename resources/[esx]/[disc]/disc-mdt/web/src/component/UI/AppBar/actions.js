export const removeNotification = (index) => {
  return {
    type: 'REMOVE_NOTIFICATION',
    payload: {
      index: index,
    },
  };
};

export const clearNotifications = () => {
  return {
    type: 'CLEAR_NOTIFICATIONS',
  };
};
