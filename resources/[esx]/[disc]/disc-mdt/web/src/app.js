import '@babel/polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';

import App from 'containers/App';

import WindowListener from 'containers/WindowListener';

import configureStore from './configureStore';
import { BrowserRouter } from 'react-router-dom';

const initialState = {};
const store = configureStore(initialState);
const MOUNT_NODE = document.getElementById('app');

const render = () => {
  ReactDOM.render(
    <BrowserRouter>
      <Provider store={store}>
        <WindowListener>
          <App/>
        </WindowListener>
      </Provider>
    </BrowserRouter>,
    MOUNT_NODE,
  );
};

if (module.hot) {
  module.hot.accept(['containers/App'], () => {
    ReactDOM.unmountComponentAtNode(MOUNT_NODE);
    render();
  });
}

render();
