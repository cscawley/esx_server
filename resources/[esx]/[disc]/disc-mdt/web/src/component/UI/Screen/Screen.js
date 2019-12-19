import { makeStyles } from '@material-ui/core';
import Paper from '@material-ui/core/Paper';
import React from 'react';

const useStyles = makeStyles(theme => ({
  paper: {
    width: '100%',
    height: '100%',
    overflow: 'auto',
    position: 'relative',
    zIndex: -1
  },
}));

export default function Screen(props) {
  const classes = useStyles();
  return (
    <Paper className={classes.paper}>
      {props.children}
    </Paper>
  );
}
