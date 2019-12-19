import Grid from '@material-ui/core/Grid';
import { makeStyles, Paper, TableCell } from '@material-ui/core';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import React, { useEffect, useState } from 'react';
import TableRow from '@material-ui/core/TableRow';
import { useSelector } from 'react-redux';
import * as lodash from 'lodash';
import TextField from '@material-ui/core/TextField';
import Nui from '../../../util/Nui';

const useStyles = makeStyles(theme => ({
  table: {
    textAlign: 'left',
  },
  tablePaper: {
    width: '100%',
    marginTop: theme.spacing(3),
    overflowX: 'auto',
    marginBottom: theme.spacing(2),
  },
  capitalize: {
    textTransform: 'capitalize',
  },
  root: {
    width: '100%',
  },
}));


export default (props) => {
  const classes = useStyles();

  const crimes = useSelector(state => state.crime.crimes);

  const [fines, setFines] = useState(0);
  const [jail, setJail] = useState(0);
  const [crimeCategory, setCrimeCategory] = useState([]);

  useEffect(() => {
    Nui.send('GetCrimes');
  }, []);

  useEffect(() => {
    const crimesMapped = props.crimes.map(crimeId => crimes.find(crime => crime.id === crimeId)).filter(value => value !== undefined);
    console.log(JSON.stringify(crimesMapped, null, 2));
    setFines(lodash.sum(crimesMapped.map(crime => crime.fine)));
    setJail(lodash.sum(crimesMapped.map(crime => crime.jailtime)));
    setCrimeCategory(lodash.countBy(crimesMapped, (value) => value.type));
  }, [props.crimes]);


  return (
    <Grid className={classes.root} container justify={'center'} alignItems={'center'}>
      <Grid item xs={12}>
        <Paper className={classes.tablePaper}>
          <Table className={classes.table} size="small" aria-label="a dense table">
            <TableBody>
              <TableRow><TableCell>Fine Total</TableCell><TableCell>${fines}</TableCell></TableRow>
              <TableRow><TableCell>Jail Total</TableCell><TableCell>{jail} Months</TableCell></TableRow>
              {lodash.keysIn(crimeCategory).map(key =>
                <TableRow><TableCell>{key}</TableCell><TableCell>{crimeCategory[key]}</TableCell></TableRow>,
              )}
            </TableBody>
          </Table>
        </Paper>
      </Grid>
      <Grid item xs={12}>
        <TextField
          className={classes.root}
          disabled={props.readonly}
          id=""
          label="Notes"
          multiline
          rowsMax="4"
          rows="2"
          value={props.notes}
          onChange={(event) => props.setNotes(event.target.value)}
          variant="outlined"
        />
      </Grid>
    </Grid>
  );
}
