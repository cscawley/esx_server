import { makeStyles, Typography } from '@material-ui/core';
import React from 'react';

const useStyles = makeStyles(theme => ({
  paper: {
    textAlign: 'center',
    fontWeight: 'bold',
    padding: theme.spacing(1),
    margin: theme.spacing(2),
  },

}));

export default (props) => {
  const classes = useStyles();

  return (
    <Typography variant={'h3'} className={classes.paper}>
      {props.title}
    </Typography>
  );
}
