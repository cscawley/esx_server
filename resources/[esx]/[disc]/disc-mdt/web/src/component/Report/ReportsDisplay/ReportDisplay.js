import React, { useEffect, useState } from 'react';
import { ExpansionPanelDetails, makeStyles } from '@material-ui/core';
import Card from '../../UI/Card/Card';
import { connect } from 'react-redux';
import ExpansionPanel from '@material-ui/core/ExpansionPanel';
import * as lodash from 'lodash';
import Typography from '@material-ui/core/Typography';
import ExpansionPanelSummary from '@material-ui/core/ExpansionPanelSummary';
import CrimeSummary from '../CrimeSummary/CrimeSummary';

const useStyles = makeStyles(theme => ({
  panel: {
    maxHeight: '30vh',
    overflow: 'auto',
  },
}));


export default connect()((props) => {
  const classes = useStyles();
  const [currentReport, setCurrentReport] = useState(0);

  useEffect(() => {
    console.log(JSON.stringify(props.reports, null, 2));
  }, [props.reports]);

  return (
    <Card title={'Last 5 Reports'} className={classes.panel} variant={'h6'}>
      {props.reports.length > 0 ? lodash.map(props.reports, (report) =>
        <ExpansionPanel expanded={currentReport === report.id}
                        onChange={(event, expanded) => expanded ? setCurrentReport(report.id) : setCurrentReport(0)}>
          <ExpansionPanelSummary className={classes.panel}>
            <Typography variant={'h6'}>
              {report.stringDate + ' ' + report.stringTime + ' Report #' + report.id}
            </Typography>
          </ExpansionPanelSummary>
          <ExpansionPanelDetails>
            <CrimeSummary crimes={report.report.crimes} notes={report.report.notes} readonly/>
          </ExpansionPanelDetails>
        </ExpansionPanel>,
      ) : <Typography variant={'body1'}>No Reports</Typography>}
    </Card>
  );
});
