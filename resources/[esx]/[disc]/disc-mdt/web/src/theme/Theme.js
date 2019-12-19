import { createMuiTheme } from '@material-ui/core';
import { blue, common, grey, red } from '@material-ui/core/colors';

const theme = (darkmode) => createMuiTheme(
  {
    typography: {},
    palette: {
      type: darkmode ? 'dark' : 'light',
      primary: {
        main: darkmode ? "#b71c1c" : blue[700],
      },
      secondary: {
        main: darkmode ? grey[400] : '#2c2f33',
      },
      error: red,
    },
    overrides: {
      MuiPaper: {
        root: {
          backgroundColor: darkmode ? '#2c2f33' : common.white,
        },
      },
      MuiDivider: {
        root: {
          backgroundColor: darkmode ? "#b71c1c" : null,
        },
      },

    },
  },
);

export default theme;
