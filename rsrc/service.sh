#!/bin/sh
#
# Startup script for the DOCKER DEPLOYED service. Expects to run as Docker root
#
# chkconfig: - 85 15
# processname: act

LOCKFILE=/var/lock/act
export PATH=/usr/local/bin:$PATH
export ACT_HOME=/usr/local/act/
export ACT_PID=$ACT_HOME/act.pid
export ACT_OPTS="-D -Djava.awt.headless=true"

# Source function library.
. /lib/lsb/init-functions

[ -f $ACT_HOME/service-runner.sh ] || exit 0

export PATH=$PATH:/usr/bin:/usr/local/bin

# See how we were called.
case "$1" in
  start)
        # Start daemon.
        echo -n "Starting Act.Framework Application: "
        $ACT_HOME/service-runner.sh -Dpidfile=$ACT_PID
        RETVAL=$?
        echo
        [ $RETVAL = 0 ] && touch $LOCKFILE
        ;;
  stop)
        # Stop daemons.
        echo -n "Shutting down Act.Framework Application: "
        kill -9 `cat $ACT_PID`
        RETVAL=$?
        echo
        [ $RETVAL = 0 ] && rm -f $LOCKFILE
        ;;
  restart)
        $0 stop
        $0 start
        ;;
  status)
        status -p $ACT_PID -l $(basename $LOCKFILE) act
        ;;
  *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit 0