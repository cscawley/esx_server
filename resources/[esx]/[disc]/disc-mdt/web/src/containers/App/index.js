import React from 'react';
import { connect, useSelector } from 'react-redux';
import PropTypes from 'prop-types';
import AppScreen from '../../component/UI/AppScreen/AppScreen';
import AppBar from '../../component/UI/AppBar/AppBar';
import { Redirect, Route, Switch } from 'react-router-dom';
import Civilians from '../../component/Civilians/Civilians';
import Crimes from '../../component/Crimes/Crimes';
import Home from '../../component/Home/Home';
import Theme from './../../theme/Theme';
import Vehicles from '../../component/Vehicles/Vehicles';
import { MuiThemeProvider } from '@material-ui/core';

const App = ({ hidden }) => {
  const darkMode = useSelector(state => state.user.darkMode);
  return (
    <MuiThemeProvider theme={Theme(darkMode)}>
      <AppScreen hidden={hidden}>
        <AppBar/>
        <Switch>
          <Route path={'/'} exact component={Home}/>
          <Route path={'/civilians'} exact component={Civilians}/>
          <Route path={'/vehicles'} exact component={Vehicles}/>
          <Route path={'/crimes'} exact component={Crimes}/>
          <Redirect to={'/'}/>
        </Switch>
      </AppScreen>
    </MuiThemeProvider>

  );
};

App.propTypes = {
  hidden: PropTypes.bool.isRequired,
};

const mapStateToProps = state => ({ hidden: state.app.hidden });

export default connect(mapStateToProps)(App);
