import AppBar from '@material-ui/core/AppBar';
import React, { Fragment } from 'react';
import { makeStyles, Toolbar } from '@material-ui/core';
import Grid from '@material-ui/core/Grid';
import { withRouter } from 'react-router-dom';
import { connect, useSelector } from 'react-redux';
import NavButton from '../NavButton/NavButton';
import Button from '@material-ui/core/Button';
import Nui from '../../../util/Nui';
import Switch from '@material-ui/core/Switch';
import { setDarkMode } from '../../User/actions';
import Notifications from './Notifications/Notifications';

const useStyles = makeStyles(theme => ({
  grid: {
    flexGrow: 1,
  },
  button: {
    width: 100,
    margin: '10px, 0px',
  },
  margin: {
    margin: theme.spacing(1),
  },
}));

export default withRouter(connect()(function MDTAppBar(props) {
  const classes = useStyles();
  const darkMode = useSelector(state => state.user.darkMode);
  const user = useSelector(state => state.user.user);
  const onExitClick = () => {
    props.dispatch({ type: 'APP_HIDE' });
    Nui.send('CloseUI');
  };

  return (
    <Fragment>
      <AppBar position="static">
        <Toolbar>
          <Grid container className={classes.grid}>
            <NavButton name={'Home'} link={'/'}/>
            <NavButton name={'Civilians'} link={'/civilians'}/>
            <NavButton name={'Vehicles'} link={'/vehicles'}/>
            <NavButton name={'Crimes'} link={'/crimes'}/>
            <NavButton name={'Most Wanted'} link={'/mostwanted'}/>
          </Grid><Switch
          checked={darkMode}
          onChange={() => {
            props.dispatch(setDarkMode(user.identifier, !darkMode));
          }}
          value="checkedA"
          color={'secondary'}
        />

          <Notifications/>
          <Button color="inherit" onClick={onExitClick}>Exit</Button>
        </Toolbar>
      </AppBar>
    </Fragment>
  );
}));
