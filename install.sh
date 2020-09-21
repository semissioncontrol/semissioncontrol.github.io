# Confirmation from user
read -p "Install SEMC on this device? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo

# Sanity checks should go here

sleep 2

# Create /semc
mkdir /semc

# Clone core
mkdir /semc/src
cd /semc/src
git clone https://github.com/semissioncontrol/core

# Initialize core installer
bash /semc/src/core/actions/install/installer.sh
