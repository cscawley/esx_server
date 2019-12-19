import { makeStyles, Paper, TableCell } from '@material-ui/core';
import React from 'react';
import Grid from '@material-ui/core/Grid';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableRow from '@material-ui/core/TableRow';
import Card from '../UI/Card/Card';
import Typography from '@material-ui/core/Typography';

const useStyles = makeStyles(theme => ({
  table: {
    textAlign: 'left',
  },
  tablePaper: {
    marginTop: theme.spacing(3),
    overflowX: 'auto',
    marginBottom: theme.spacing(2),
  },
  capitalize: {
    textTransform: 'capitalize',
  },
}));

export default (props) => {
  const classes = useStyles();

  return (
    <Card title={props.data.name}>
      <Grid item xs={6}>
        <Paper className={classes.tablePaper}>
          <Table className={classes.table} size="small" aria-label="a dense table">
            <TableBody>
              <TableRow><TableCell>Fine</TableCell><TableCell>{props.data.fine}</TableCell></TableRow>
              <TableRow><TableCell>Jail Time</TableCell><TableCell>{props.data.jailtime}</TableCell></TableRow>
              <TableRow><TableCell>Type</TableCell><TableCell>{props.data.type}</TableCell></TableRow>
              <TableRow><TableCell>Description</TableCell><TableCell><Typography variant={'body2'}>{props.data.description}</Typography></TableCell></TableRow>
            </TableBody>
          </Table>
        </Paper>
      </Grid>
    </Card>
  );

}
