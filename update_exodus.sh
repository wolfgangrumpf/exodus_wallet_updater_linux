#!/bin/bash

# This script will auto-update Exodus
# To run:  ./update_exodus.sh <version>, e.g.:
# ./update_exodus.sh 21.3.12


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
    wget -nc https://downloads.exodus.com/releases/exodus-linux-x64-${current}.deb

    # Now let's install
    sudo dpkg -i exodus-linux-x64-${current}.deb
    # Now cleanup
    rm *.deb
  else
    echo "No new version available - terminating"
fi

# cleanup and done!
rm versioncheck.txt
