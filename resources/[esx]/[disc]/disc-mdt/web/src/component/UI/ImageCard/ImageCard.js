import { connect } from 'react-redux';
import React from 'react';
import Img from 'react-image';
import { makeStyles } from '@material-ui/core';
import Paper from '@material-ui/core/Paper';
import CircularProgress from '@material-ui/core/CircularProgress';
import Typography from '@material-ui/core/Typography';
import Grid from '@material-ui/core/Grid';

const useStyles = makeStyles(theme => ({
  paper: {
    position: 'relative',
    marginTop: theme.spacing(2),
    marginBottom: theme.spacing(2),
    padding: theme.spacing(1),
  },
  title: {
    textAlign: 'center',
    padding: theme.spacing(2),
  },
  img: {
    maxWidth: "100%",
    maxHeight: "100%"
  }
}));

export default connect()((props) => {
  const classes = useStyles();

  return (
    <Paper className={classes.paper}>
      <Grid container justify={'center'} alignItems={'center'}>
        <Img className={classes.img} src={props.url} loader={<CircularProgress/>}
             unloader={<Typography variant={'h6'} className={classes.title}>No Image, Upload one</Typography>}/>
      </Grid>
    </Paper>
  );
});
