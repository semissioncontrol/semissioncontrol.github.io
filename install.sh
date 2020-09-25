# Functions
function installDirectory {
    # Create /semc
    mkdir /semc

    mkdir /semc/bin
    echo 'export PATH=$PATH:/semc/bin' >> ~/.bashrc
    echo "Updated PATH"

    # Clone core
    mkdir /semc/src
    cd /semc/src
    git clone https://github.com/semissioncontrol/core
}

# Version
echo "SEMC installer v0.1.1"

# Confirmation from user
read -p "Install SEMC on this device? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborting..."
    exit 1
fi

echo

# Sanity checks

# Internet connection
wget -q --spider http://github.com
if [ $? -eq 0 ]; then 
    echo "Good: Internet Connection found."
else
    echo "Error: Internet Connection not found!"
    exit
fi

# Sudo access
if [ "$EUID" -ne 0 ]
  then echo "Error: Please run as root."
  exit
fi
echo "Good: Root access found"

# GCC
if ! command -v gcc &> /dev/null
then
    echo "Error: GCC not installed, quitting..."
    exit 1
fi

# Make
if ! command -v make &> /dev/null
then
    echo "Error: Make not installed, quitting..."
    exit 1
fi

# Check if semcOS is being used
if ! command -v semc-install &> /dev/null
then
    read -p "semcOS not found. Proceed to install on this OS? " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
    
    for i in {1..5}
    do
        echo "Installing in $i...\r"
        sleep 1
    done
    
    echo
    
    # semcOS is not being used, but user wants to proceed
    installDirectory
    
    # Initialize core installer
    bash /semc/src/core/actions/install/installer.sh

    exit 0
fi

# User is using semcOS

# Check if gcc is available
if ! command -v gcc &> /dev/null
then
    read -p "GCC not found. Install? " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installation cannot proceed without GCC."
        exit 1
    fi
    
    # Since we're allowed now, install gcc
    xbps-install gcc
fi

if ! command -v make &> /dev/null
then
    read -p "Make not found. Install? " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installation cannot proceed without make."
        exit 1
    fi
    
    # Since we're allowed now, install make
    xbps-install make
fi

for i in {1..5}
do
    echo "Installing in $i...\r"
    sleep 1
done

echo

xbps-install -Suv
installDirectory
bash /semc/src/core/actions/install/installer.sh
