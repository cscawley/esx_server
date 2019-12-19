import { NavLink } from 'react-router-dom';
import React from 'react';
import Button from '@material-ui/core/Button';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  margin: {
    margin: theme.spacing(1),
  },
  extendedIcon: {
    marginRight: theme.spacing(1),
  },
}));

export default function NavButton(props) {
  const classes = useStyles();

  return (
    <NavLink className={classes.margin} to={props.link} style={{ textDecoration: 'none', color: 'inherit' }}>
      <Button size={'large'}>{props.name}</Button>
    </NavLink>
  );
}
