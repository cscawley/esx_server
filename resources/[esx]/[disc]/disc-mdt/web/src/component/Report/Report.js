import { makeStyles, Typography } from '@material-ui/core';
import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import Card from '../UI/Card/Card';
import DialogModal from '../UI/Modal/DialogModal';
import Fab from '@material-ui/core/Fab';
import DialogActions from '@material-ui/core/DialogActions';
import AddIcon from '@material-ui/icons/Add';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import CrimeSelector from '../Crimes/CrimeSelector/CrimeSelector';
import { grey } from '@material-ui/core/colors';
import CrimeSummary from './CrimeSummary/CrimeSummary';
import { getLocation, getTime } from '../User/actions';
import { postReport } from './actions';

const useStyles = makeStyles(theme => ({
  textField: {
    width: '100%',
  },
  grid: {
    width: '100%',
  },
  insideGrid: {
    width: '90%',
  },
  '@global': {
    '*::-webkit-scrollbar': {
      width: 10,
      marginLeft: theme.spacing(1),
      marginTop: theme.spacing(1),
      marginBottom: theme.spacing(1),
    },
    '*::-webkit-scrollbar-track': {
      boxShadow: 'inset 0 0 1px grey',
      borderRadius: 10,
    },
    '*::-webkit-scrollbar-thumb': {
      background: grey[500],
      borderRadius: 10,
      '&:hover': {
        background: grey[700],
      },
    },
  },
}));


export default connect()((props) => {
  const classes = useStyles();
  const user = useSelector(state => state.user.user);
  const [form, setForm] = useState({
    officer: '',
    officerIdentifier: '',
    player: '',
    playerIdentifier: '',
  });

  const [crimes, setCrimes] = useState([]);
  const [notes, setNotes] = useState('');
  const location = useSelector(state => state.user.location);
  const date = useSelector(state => state.user.datetime.date);
  const time = useSelector(state => state.user.datetime.time);
  const currentSearch = useSelector(state => state.civ.currentSearch);

  useEffect(() => {
    if (props.open) {
      getLocation();
      props.dispatch(getTime());
      setProperty('officer', [user.firstname, user.lastname].join(' '));
      setProperty('officerIdentifier', user.identifier);
      setProperty('player', [props.data.firstname, props.data.lastname].join(' '));
      setProperty('playerIdentifier', props.data.identifier);
    }
  }, [props.open]);

  const setProperty = (propName, value) => {
    setForm(form => {
      const newForm = { ...form };
      newForm[propName] = value;
      return newForm;
    });
  };

  const handleCrime = (crimeId) => {
    setCrimes(crimes => {
      const newCrimes = [...crimes];
      const currentIndex = newCrimes.indexOf(crimeId);
      if (currentIndex === -1) {
        newCrimes.push(crimeId);
      } else {
        newCrimes.splice(currentIndex, 1);
      }
      return newCrimes;
    });
  };

  const postForm = () => {
    props.dispatch(postReport(form, location, date, time, crimes, notes, currentSearch));
    props.setModalState(false);
  };

  const handleDateChange = (date) => {
    console.log(date);
  };
  return (
    <DialogModal open={props.open} setModalState={props.setModalState}>
      <Card title={'Report'}>
        <Grid container justify={'center'} alignItems={'center'} className={classes.grid} spacing={3}>
          <Grid container justify={'flex-start'} alignItems={'center'} className={classes.insideGrid} spacing={3}>
            <Grid item xs={4}>
              <TextField disabled value={form.officer} variant={'outlined'} className={classes.textField}
                         label={'Officer'}/>
            </Grid>
            <Grid item xs={4}>
              <TextField value={location.street} variant={'outlined'} className={classes.textField}
                         label={'Street'}/>
            </Grid>
            <Grid item xs={4}>
              <TextField value={location.area} variant={'outlined'} className={classes.textField}
                         label={'Area'}/>
            </Grid>
            <Grid item xs={4}>
              <TextField disabled value={form.player} variant={'outlined'} className={classes.textField}
                         label={'Reported'}/>
            </Grid>
            <Grid item xs={4}>
              <TextField
                id="time"
                label="Incident Time"
                variant={'outlined'}
                type="time"
                value={time}
                className={classes.textField}
                InputLabelProps={{
                  shrink: true,
                }}
              />
            </Grid>
            <Grid item xs={4}>
              <TextField
                id="date"
                label="Date"
                variant={'outlined'}
                type="date"
                value={date}
                className={classes.textField}
                InputLabelProps={{
                  shrink: true,
                }}
              />
            </Grid>
            <Grid item xs={6}>
              <Typography variant={'h6'}>Crimes Committed</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography variant={'h6'}>Report Summary</Typography>
            </Grid>
            <Grid item xs={6}>
              <CrimeSelector handleCrime={handleCrime}
                             selectedCrimes={crimes}/>
            </Grid>
            <Grid item xs={6}>
              <CrimeSummary crimes={crimes} notes={notes} setNotes={setNotes}/>
            </Grid>
          </Grid>
        </Grid>
      </Card>
      <DialogActions>
        <Fab onClick={postForm}>
          <AddIcon/>
        </Fab>
      </DialogActions>
    </DialogModal>
  );
});
