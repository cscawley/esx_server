import Card from '../UI/Card/Card';
import React from 'react';
import Screen from '../UI/Screen/Screen';
import Grid from '@material-ui/core/Grid';
import { useSelector } from 'react-redux';
import { makeStyles, Paper, TableCell } from '@material-ui/core';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableRow from '@material-ui/core/TableRow';
import ImageCard from '../UI/ImageCard/ImageCard';

const useStyles = makeStyles(theme => ({
  table: {
    textAlign: 'left',
  },
  tablePaper: {
    overflowX: 'auto',
  },
}));

export default (props) => {
  const classes = useStyles();
  const user = useSelector(state => state.user.user);

  return (<Screen>
      <Grid item xs={12}>
        <Card title={user.firstname + ' ' + user.lastname}>
          <Grid spacing={3} justify={'center'} alignItems={'stretch'} container>
            <Grid item xs={6}>
              <Paper className={classes.tablePaper}>
                <Table className={classes.table} size="small" aria-label="a dense table">
                  <TableBody>
                    <TableRow><TableCell>Date of
                      Birth</TableCell><TableCell>{user.dateofbirth}</TableCell></TableRow>
                    <TableRow><TableCell>Height</TableCell><TableCell>{user.height} cm</TableCell></TableRow>
                    <TableRow><TableCell>Sex</TableCell><TableCell>{user.sex.toLowerCase() === 'm' ? 'Male' : 'Female'}</TableCell></TableRow>
                    <TableRow><TableCell>Phone Number</TableCell><TableCell>{user.phone_number}</TableCell></TableRow>
                  </TableBody>
                </Table>
              </Paper>
            </Grid>
            <Grid item xs={6}>
              <ImageCard url={user.userimage}/>
            </Grid>
          </Grid>
        </Card>
      </Grid>
    </Screen>
  );
}
