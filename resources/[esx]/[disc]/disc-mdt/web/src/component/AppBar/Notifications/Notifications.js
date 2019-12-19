import Popper from '@material-ui/core/Popper';
import Paper from '@material-ui/core/Paper';
import ClickAwayListener from '@material-ui/core/ClickAwayListener';
import MenuList from '@material-ui/core/MenuList';
import React, { Fragment, useEffect } from 'react';
import Grow from '@material-ui/core/Grow';
import { makeStyles } from '@material-ui/core';
import Badge from '@material-ui/core/Badge/Badge';
import NotificationImportantIcon from '@material-ui/icons/NotificationImportant';
import IconButton from '@material-ui/core/IconButton';
import { connect, useSelector } from 'react-redux';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';
import CancelIcon from '@material-ui/icons/Cancel';
import List from '@material-ui/core/List';
import { clearNotifications, removeNotification } from '../actions';
import UIFx from 'uifx'
import notification from '/notification.wav'

const useStyles = makeStyles(theme => ({
  higher: {
    zIndex: 99999,
  },
}));

export default connect()((props) => {
  const classes = useStyles();
  const [open, setOpen] = React.useState(false);
  const anchorRef = React.useRef(null);
  const notifications = useSelector(state => state.appBar.notifications);

  const bell = new UIFx({asset: notification});

  useEffect(() => {
    bell.play();
  }, [notifications]);



  const handleToggle = () => {
    setOpen(prevOpen => !prevOpen);
  };

  const handleClose = event => {
    if (anchorRef.current && anchorRef.current.contains(event.target)) {
      return;
    }
    setOpen(false);
  };

  // return focus to the button when we transitioned from !open -> open
  const prevOpen = React.useRef(open);
  React.useEffect(() => {
    if (prevOpen.current === true && open === false) {
      anchorRef.current.focus();
    }

    prevOpen.current = open;
  }, [open]);

  return (
    <Fragment>
      <IconButton size={'small'} onClick={handleToggle} ref={anchorRef}>
        <Badge color="secondary" badgeContent={notifications.length} invisible={notifications.length <= 0}
               className={classes.margin}>
          <NotificationImportantIcon/>
        </Badge>
      </IconButton>
      <Popper open={open} anchorEl={anchorRef.current} role={undefined} transition disablePortal
              className={classes.higher}>
        {({ TransitionProps, placement }) => (
          <Grow className={classes.higher}
                {...TransitionProps}
                style={{ transformOrigin: placement === 'bottom' ? 'center top' : 'center bottom' }}
          >
            <Paper className={classes.higher}>
              <ClickAwayListener onClickAway={handleClose} className={classes.higher}>
                <MenuList autoFocusItem={open} id="menu-list-grow"
                          className={classes.higher}>
                  <List dense>
                    {notifications.length > 1 && <ListItem disabled disableRipple>
                      <ListItemText>Clear All</ListItemText>
                      <IconButton onClick={() => props.dispatch(clearNotifications())}><CancelIcon/></IconButton>
                    </ListItem>}
                    {notifications.map((notif, index) =>
                      <ListItem disabled disableRipple>
                        <ListItemText>{notif.message}</ListItemText>
                        <IconButton onClick={() => props.dispatch(removeNotification(index))}><CancelIcon/></IconButton>
                      </ListItem>)
                    }
                  </List>
                </MenuList>
              </ClickAwayListener>
            </Paper>
          </Grow>
        )}
      </Popper>
    </Fragment>
  );
});
