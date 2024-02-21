#!/bin/bash

# This script will auto-update Exodus
# To run:  ./update_exodus.sh <version>, e.g.:
# ./update_exodus.sh 21.3.12

# First see if lynx is install
if ! command -v lynx &> /dev/null
then
    echo "Please install lynx before executing this script - exiting now"
    exit 1
fi

# Version check - make sure we are actually downloading/installing a new version

apt-cache policy exodus > versioncheck.txt

# compare installed vs candidate

current=$(lynx -dump https://www.exodus.com/releases/index.html | grep "new in" | tr -d [:upper:] | tr -d [:lower:] | awk '{print $2}')

installed=$(grep Installed versioncheck.txt | awk '{print $2}' | sed 's/.\{2\}$//')

echo "Installed version:  $installed"
echo "Requested version:  $current"


if [ "$current" != "$installed" ]
  then
    echo "New Version Available - Installing"
    # Download version in "no clobber mode"
    wget --user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" -nc https://downloads.exodus.com/releases/exodus-linux-x64-${current}.deb
    echo "getting https://downloads.exodus.com/releases/exodus-linux-x64-${current}.deb"
    # Now let's install
    sudo dpkg -i exodus-linux-x64-${current}.deb
    # Now cleanup
    rm *.deb
  else
    echo "No new version available - terminating"
fi

# cleanup and done!
rm versioncheck.txt
