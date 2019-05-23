# Cisco DNA Spaces Location Sample for iOS
The sample applicaiton provides implementation examples for using the Cisco DNA Spaces Location SDK. The project does not include the SDK. The SDK needs to be downloaded from [https://dnaspaces.io/](https://dnaspaces.io/). The project runs with simulation mode enabled and will not require a Cisco DNA Spaces tenant or other dependency. The client movement is articifically simulated for testing and develpment.

# Installation
The sample applicaiton requires the Cisco DNA Spaces Location SDK which is not included in the repository. [CocoaPods](https://cocoapods.org/) is required to install the SDK. The installation can be done by following the below steps.

 * Download the **DnaLocation.zip** file from [https://dnaspaces.io/](https://dnaspaces.io/) in the Location Experiences Manager application.
 * Put the **DnaLocation.zip** into the **DnaInstall** folder.
 * Run the shell script `dna_mobile_sdk_install.sh`. This script will install the SDK for the sample application. If an existing version of the SDK were installed then the version would be replaced with the new version.
 * The installation will create **DnaLocationSample.xcworkspace** in the **DnaLocationSampleApp** directory. This is the file to open when using Xcode.

# Running
Launch Xcode and open the **DnaLocationSample.xcworkspace** in the **DnaLocationSampleApp** directory. The application can be run in a simulator or using an attached device. The application is a simple tabbed application. Each tab demonstrates different features of the SDK.

### Location Updates
The first tab demonstrates how to start location updates and receive asynchronous location updates in the application. The user interface table shows the current location and updates the table as new updates are received.

### Map Location Updates
The second tab demonstrates how to download a map and display the current location on the map with a blue dot. The blue dot will move on the map as the location updates are received.

### Points of Interest
The third tab demonstrates how to get the points of interest for a floor. Points of interest contain a number of attributes and can be used for navigation and send notifications when passing by a point of interest.

### Routing
THe fourth tab demonstrates how to initiate a route request and have the route returned.