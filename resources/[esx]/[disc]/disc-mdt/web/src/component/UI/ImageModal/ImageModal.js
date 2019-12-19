import Grid from '@material-ui/core/Grid';
import { DialogActions, makeStyles, TextField, Typography } from '@material-ui/core';
import Divider from '@material-ui/core/Divider';
import ImageCard from '../ImageCard/ImageCard';
import Fab from '@material-ui/core/Fab';
import PublishIcon from '@material-ui/icons/Publish';
import React, { useEffect, useState } from 'react';
import DialogContent from '@material-ui/core/DialogContent';
import DialogModal from '../Modal/DialogModal';

const useStyles = makeStyles(theme => ({
  dialog: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: theme.spacing(2),
    '@media (max-width: 900px)': {
      margin: theme.spacing(5),
    },
  },
  title: {
    textAlign: 'center',
    padding: theme.spacing(1),
  },
  textField: {
    width: '100%',
  },
  fabPhoto: {
    position: 'absolute',
    bottom: theme.spacing(2),
    right: theme.spacing(2),
  },
}));

export default (props) => {
  const classes = useStyles();

  const [url, setUrl] = useState('');

  useEffect(() => {
    setUrl(props.selectedImage);
  }, [props.selectedImage]);

  return (
    <DialogModal open={props.open} setModalState={props.setModalState} className={classes.dialog}>
      <DialogContent>
        <Grid spacing={0} justify={'center'} alignItems={'center'}>
          <Grid item xs={12}>
            <Typography variant={'h4'} className={classes.title}>{props.title}</Typography>
          </Grid>
          <Divider/>
          <ImageCard url={props.selectedImage}/>
          <Grid item xs={12}>
            <TextField variant={'outlined'} className={classes.textField} value={url}
                       onChange={(event) => setUrl(event.target.value)}/>
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions>
        <Fab aria-label="add" onClick={() => props.setImage(url)}>
          <PublishIcon/>
        </Fab>
      </DialogActions>
    </DialogModal>
  );
}
