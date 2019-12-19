import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core';
import InputAdornment from '@material-ui/core/InputAdornment';
import IconButton from '@material-ui/core/IconButton';
import SearchIcon from '@material-ui/icons/Search';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';

const useStyles = makeStyles(theme => ({
  grid: {
    width: '100%',
  },
  textField: {
    width: '100%',
  },
}));


export default function SearchBar(props) {
  const classes = useStyles();
  const [value, setValue] = useState('');
  const handleEnter = (event) => {
    if (event.keyCode === 13) {
      props.search(event.target.value);
    }
  };

  return (
    <Grid className={classes.grid}>
      <TextField
        label={props.label ? props.label : 'Search'}
        id="filled-start-adornment"
        className={classes.textField}
        InputProps={{
          endAdornment:
            !props.instant && <InputAdornment position="end">
              <IconButton
                onClick={() => props.search(value)}
              >
                <SearchIcon/>
              </IconButton>
            </InputAdornment>,
        }}
        onChange={(event) => {
          setValue(event.target.value);
          if (props.instant) {
            props.search(event.target.value);
          }
        }}
        onKeyDown={handleEnter}
        value={value}
        variant="outlined"
      />
    </Grid>

  );
}
