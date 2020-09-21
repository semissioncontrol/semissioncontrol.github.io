# Confirmation from user
read -p "Install SEMC on this device? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo

# Reset sanity variables
export NOGITSEMC=false
export NOINTERNETSEMC=false
export NOROOTPERMSSEMC=true


# Add sanity checks here
echo "Performing sanity checks"

echo "[1/3] Git"
git --version || export NOGITSEMC=true

echo "[2/3] Internet Connection"
wget -q --spider github.com || export NOINTERNETSEMC=true

echo "[3/3] Root permissions"
sudo -v || export NOROOTPERMSSEMC=true

if [ $NOGITSEMC ]
then
  echo "Error! Git not found!"
  exit 1
fi
if [ $NOINTERNETSEMC ]
then
  echo "Error! No internet connection found! (or github.com is down)"
  exit
fi
if [ $NOROOTPERMSSEMC ]
then
  echo "Error! Root permissions not found. Please re-run with root permissions."
  exit 1
fi

echo "Sanity checks complete. Beginning installation."
sleep 2

# Create /semc
mkdir /semc

# Clone core
mkdir /semc/src
cd /semc/src
git clone https://github.com/semissioncontrol/core

# Initialize core installer
