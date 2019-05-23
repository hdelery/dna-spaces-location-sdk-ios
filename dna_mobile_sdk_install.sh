#
# Install a new DNA Location SDK using the zip file
# Download SDK zip file and place into DnaInstall directory
#

script=$0
scriptDir="$(dirname $script)"
dnaInstallDir="$scriptDir/DnaInstall"
dnaInstallZip="$dnaInstallDir/DnaLocation.zip"
dnaSdkDir="$scriptDir/DnaLocation"
dnaLocationSampleApp="$scriptDir/DnaLocationSampleApp"

if ! type "pod" > /dev/null; then
  echo "ERROR: Missing CocoaPods installation. Run 'sudo gem install cocoapods --pre' to install"
  exit 1
fi

if [ ! -d $dnaInstallDir ]; then
  echo "ERROR: Directory: $dnaInstallDir does not exist. Create directory and place DNA Location SDK zip file into directory"
  exit 1
fi

if [ ! -f $dnaInstallZip ]; then
  echo "ERROR: Install file: $dnaInstallZip does not exist. Place DNA Location SDK zip file into install directory: $dnaInstallDir"
  exit 1
fi

rm -rf $dnaSdkDir/*
unzip $dnaInstallZip -d $dnaSdkDir

pushd $dnaLocationSampleApp
rm -rf Pods
rm -rf Podfile.lock
pod install
if [ $? -ne 0 ]; then
  echo "ERROR: Failed to install the CocoaPod library DNA Location SDK"
  popd
  exit 1
fi
popd

echo "SUCCESS: Completed install of new DNA Spaces Location SDK successfully"
