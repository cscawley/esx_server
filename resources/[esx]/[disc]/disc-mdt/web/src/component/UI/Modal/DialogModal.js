import React from 'react';
import { Dialog, DialogContent, makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  form: {
    display: 'flex',
    flexDirection: 'column',
    margin: 'auto',
    width: 'fit-content',
    position: 'relative',
  },
}));

export default function DialogModal(props) {
  const classes = useStyles();

  return (
    <Dialog open={props.open} onClose={() => props.setModalState(false)} fullWidth maxWidth={props.maxWidth ? props.maxWidth : "lg"}>
      <DialogContent>
        {props.children}
      </DialogContent>
    </Dialog>
  );
}
