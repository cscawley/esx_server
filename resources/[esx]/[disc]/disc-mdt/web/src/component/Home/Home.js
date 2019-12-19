import Screen from '../UI/Screen/Screen';
import React from 'react';
import AddAlertIcon from '@material-ui/icons/AddAlert';
import Grid from '@material-ui/core/Grid';

export default function Home(props) {
  return (
    <Screen>
      <Grid container justify={'center'} alignItems={'center'}>
        <AddAlertIcon/>
      </Grid>
    </Screen>
  );
}
