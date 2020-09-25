# Confirmation from user
read -p "Install SEMC on this device? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo

# Sanity checks
wget -q --spider http://github.com

if [ $? -eq 0 ]; then
    echo "Internet Connection found"
else
    echo "Internet Connection not found!"
    exit
fi

# Check if semcOS is being used
if ! command -v semc-install &> /dev/null
then
    read -p "semcOS not found. Proceed to install on this OS? " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
    
    # semcOS is not being used, but user wants to proceed
    installDirectory
    
    # Initialize core installer
    bash /semc/src/core/actions/install/installer.sh

    exit 0
fi

# User is indeed using semcOS
xbps-install -Suv
installDirectory
bash /semc/src/core/actions/install/installer.sh

function installDirectory {
    # Create /semc
    mkdir /semc

    # Clone core
    mkdir /semc/src
    cd /semc/src
    git clone https://github.com/semissioncontrol/core
}
