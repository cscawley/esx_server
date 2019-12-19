import { useSelector } from 'react-redux';
import React, { Fragment } from 'react';

export default (props) => {
  props.jobs = props.jobs ? props.jobs : [];

  const job = useSelector(state => state.user.user.job);

  return props.jobs.includes(job) ? <Fragment>{props.children}</Fragment> : <Fragment/>;
}
