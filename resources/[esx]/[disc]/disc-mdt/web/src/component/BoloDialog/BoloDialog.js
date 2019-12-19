import { Dialog } from '@material-ui/core';
import React from 'react';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions';
import Button from '@material-ui/core/Button';

export default (props) => {
  const handleCancel = () => {
    props.setModalState(false);
  };

  const handleIssue = () => {
    props.setModalState(false);
    props.issue();
  };

  return (
    <Dialog open={props.open} onClose={props.setModalState}>
      <DialogContent>
        <DialogContentText>
          {props.active ? 'Remove BOLO for ' + props.identifier : 'Issue BOLO for' + props.identifier}
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={handleCancel} color="primary">
          Cancel
        </Button>
        <Button onClick={handleIssue} color="primary">
          {props.active ? 'Remove' : 'Issue'}
        </Button>
      </DialogActions>
    </Dialog>);
}
