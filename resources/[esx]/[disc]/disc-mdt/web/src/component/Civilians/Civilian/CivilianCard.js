import { makeStyles, Paper, TableCell } from '@material-ui/core';
import React from 'react';
import Grid from '@material-ui/core/Grid';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableRow from '@material-ui/core/TableRow';
import Fab from '@material-ui/core/Fab';
import InfoIcon from '@material-ui/icons/Info';
import PhotoCameraIcon from '@material-ui/icons/PhotoCamera';
import Card from '../../UI/Card/Card';

const useStyles = makeStyles(theme => ({
  table: {
    textAlign: 'left',
  },
  tablePaper: {
    marginTop: theme.spacing(3),
    overflowX: 'auto',
    marginBottom: theme.spacing(2),
  },
  infoFab: {
    position: 'absolute',
    margin: theme.spacing(1),
    bottom: theme.spacing(0),
    right: theme.spacing(1),
  },
  pictureFab: {
    position: 'absolute',
    margin: theme.spacing(1),
    top: theme.spacing(0),
    right: theme.spacing(1),
  },
  capitalize: {
    textTransform: 'capitalize',
  },
}));

export default function CivilianCard(props) {
  const classes = useStyles();

  const onInfoClick = () => {
    props.setSelectedCivilian(props.data);
    props.setModalState(true);
  };

  const onPhotoClick = () => {
    props.setSelectedCivilian(props.data);
    props.setPhotoModalState(true);
  };


  return (
    <Card title={props.data.firstname + ' ' + props.data.lastname}>
      <Grid item xs={6}>
        <Paper className={classes.tablePaper}>
          <Table className={classes.table} size="small" aria-label="a dense table">
            <TableBody>
              <TableRow><TableCell>Date of Birth</TableCell><TableCell>{props.data.dateofbirth}</TableCell></TableRow>
              <TableRow><TableCell>Height</TableCell><TableCell>{props.data.height} cm</TableCell></TableRow>
              <TableRow><TableCell>Sex</TableCell><TableCell>{props.data.sex.toLowerCase() === 'm' ? 'Male' : 'Female'}</TableCell></TableRow>
            </TableBody>
          </Table>
        </Paper>
      </Grid>
      {!props.hideFab && (<Fab aria-label="like" className={classes.infoFab} onClick={onInfoClick}>
        <InfoIcon/>
      </Fab>)}
      {!props.hideFab && <Fab className={classes.pictureFab} onClick={onPhotoClick}>
        <PhotoCameraIcon/>
      </Fab>}
    </Card>
  );

}
