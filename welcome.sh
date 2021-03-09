#!/bin/bash


export NAME=$(whoami)
export LCSET=$(awk 'NR==1' locationset.txt 2> /dev/null)
export LOCATION=$(awk 'NR==2' locationset.txt 2> /dev/null)
export ENDT="$(date -u +%F)T23:59:59"
export DAGO="$(date -u +"%Y-%m-%dT%H:%M:%S" --date='7 days ago')"

if [[ $LCSET = true ]]
then
  echo "Welcome $NAME !"
  echo "Today's weather:"
  curl wttr.in/$LOCATION

  rm -rf /tmp/earthquake.txt

  wget --quiet -O /tmp/earthquake.txt "http://webservices.ingv.it/fdsnws/event/1/query?starttime=$DAGO&endtime=$ENDT&minmag=2&maxmag=10&mindepth=-10&maxdepth=1000&minlat=-90&maxlat=90&minlon=-180&maxlon=180&minversion=100&orderby=time-asc&format=text&limit=10000"
  echo -e "\nRecent earthquakes with magnitude:"
  awk -F"|" '{ print $2 "  "$11"  "$13 }' /tmp/earthquake.txt | sort -n | tail
 
  
  exit 0
  
else
  echo -n "Write your location for meteo: "
  read "LOCATIONW"
  echo "true" > locationset.txt
  echo "$LOCATIONW" >> locationset.txt
  
  echo "Welcome $NAME\b!"
  echo "Today's weather:"
  curl wttr.in/$LOCATIONW

  echo -e "\nRecent earthquakes with magnitude (UTC Time):"
  wget --quiet -O /tmp/earthquake.txt "http://webservices.ingv.it/fdsnws/event/1/query?starttime=$DAGO&endtime=$ENDT&minmag=2&maxmag=10&mindepth=-10&maxdepth=1000&minlat=-90&maxlat=90&minlon=-180&maxlon=180&minversion=100&orderby=time-asc&format=text&limit=10000"
  awk -F"|" '{ print $2 "  "$11"  "$13 }' /tmp/earthquake.txt | sort -n | tail

  rm -rf /tmp/earthquake.txt 

  exit 0

fi

