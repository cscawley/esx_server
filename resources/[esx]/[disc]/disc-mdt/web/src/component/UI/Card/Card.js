import { makeStyles, Paper, Typography } from '@material-ui/core';
import Grid from '@material-ui/core/Grid';
import Divider from '@material-ui/core/Divider';
import React from 'react';

const useStyles = makeStyles(theme => ({
  paper: {
    position: 'relative',
    marginTop: theme.spacing(2),
    marginBottom: theme.spacing(2),
    padding: theme.spacing(1),
  },
  grid: {
    padding: theme.spacing(1),
    marginBottom: theme.spacing(0)
  },
}));

export default (props) => {
  const classes = useStyles();

  return (
    <Paper className={classes.paper}>
      <Grid container justify={'left'} alignItems={'left'} spacing={3} className={classes.grid}>
        <Grid item xs={12}>
          <Typography variant={props.variant ? props.variant : "h4"}>{props.title}</Typography>
        </Grid>
        <Grid item xs={12}>
          <Divider/>
        </Grid>
        <Grid item xs={12}>
          {props.children}
        </Grid>
      </Grid>
    </Paper>);

}
