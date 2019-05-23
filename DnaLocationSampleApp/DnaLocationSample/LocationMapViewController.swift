import UIKit
import DnaLocation

class LocationMapViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var cmxMapScrollView: UIScrollView!
    
    var map: UIImageView!
    var feetToPixelRatioWidth : CGFloat?
    var feetToPixelRatioLength : CGFloat?
    var currentClientLocation: DnaDeviceLocation?
    var mapViewDisplayed: Bool!
    var hasLocatedClient: Bool!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DnaLocationClient.startLocationUpdates(onUpdate: self.clientLocationUpdate, onNotification: self.notificationUpdate)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DnaLocationClient.stopLocationUpdates()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return map;
    }
    
    func getMap(_ cmxClientLocation: DnaDeviceLocation) {
        DnaLocationClient.getMap(onCompletion: self.onCompletionOfGetMap)
    }
    
    func onCompletionOfGetMap(_ map: UIImage?, _ mapInfo: DnaMapInfo?, _ error: Error?) {
        // Deleting previous maps so that only one map is in the view at one time
        if self.cmxMapScrollView.subviews.count > 0 {
            for subview in self.cmxMapScrollView.subviews {
                subview.removeFromSuperview();
            }
        }
        // Generating the correct map sizing
        let mapCorrectImageViewWidth : CGFloat = (self.cmxMapScrollView.frame.height/map!.size.height) * map!.size.width;
        let x : CGFloat = 0
        let y : CGFloat = 0
        let height : CGFloat = self.cmxMapScrollView.frame.height;
        self.map = UIImageView(image: map);
        self.map.frame = CGRect(x: x, y: y, width: mapCorrectImageViewWidth, height: height);
        self.cmxMapScrollView.addSubview(self.map);
        
        // Determine the ratio between CMX location and pixels for the image
        let feetWidth : CGFloat = CGFloat(mapInfo!.width)
        feetToPixelRatioWidth = feetWidth/mapCorrectImageViewWidth;
        let feetLength : CGFloat = CGFloat(mapInfo!.length)
        feetToPixelRatioLength = feetLength/height;
        
        // Place blue dot on the map
        let userLocationImage : UIImageView = UIImageView(image: UIImage(named: "blueIcon.png"));
        userLocationImage.tag = 10
        let locationImageX: CGFloat = ((CGFloat(self.currentClientLocation!.floorCoordinate.x))/feetToPixelRatioWidth!) - 7.0
        let locationImageY: CGFloat = ((CGFloat(self.currentClientLocation!.floorCoordinate.y))/feetToPixelRatioLength!) - 7.0
        userLocationImage.frame = CGRect(x: locationImageX, y: locationImageY, width: 15, height: 15);
        self.map.addSubview(userLocationImage);
        
        self.cmxMapScrollView.maximumZoomScale = 10.0;
        self.cmxMapScrollView.zoomScale = 1.0;
        
        self.mapViewDisplayed = true
        self.activityIndicator.stopAnimating();
        
    }
    
    func clientLocationUpdate(_ cmxClientLocation: DnaDeviceLocation?, _ error: Error?) {
        if self.currentClientLocation?.floorId != cmxClientLocation?.floorId {
            self.currentClientLocation = cmxClientLocation
            getMap(cmxClientLocation!)
            return
        }
        self.currentClientLocation = cmxClientLocation
        if self.mapViewDisplayed == true {
            
            // Place blue dot on the map
            let userLocationImage : UIImageView = UIImageView(image: UIImage(named: "blueIcon.png"));
            userLocationImage.tag = 10
            
            // Adjust the blue dot image size based upon the zoom level
            var locationImageZoomSize: CGFloat = 1.0
            if feetToPixelRatioWidth!/self.cmxMapScrollView.zoomScale > 1 {
                locationImageZoomSize = self.cmxMapScrollView.zoomScale
            }
            let imageSize = 15 / locationImageZoomSize
            let locationImageX: CGFloat = ((CGFloat(self.currentClientLocation!.floorCoordinate.x))/feetToPixelRatioWidth!) - (imageSize/2)
            let locationImageY: CGFloat = ((CGFloat(self.currentClientLocation!.floorCoordinate.y))/feetToPixelRatioLength!) - (imageSize/2)
            userLocationImage.frame = CGRect(x: locationImageX, y: locationImageY, width: imageSize, height: imageSize)
            
            // Remove any existing blue dot using the tag
            if self.map.subviews.count > 0 {
                while (self.view.viewWithTag(10) != nil) {
                    let viewWtihTag = self.view.viewWithTag(10)
                    viewWtihTag?.removeFromSuperview()
                }
            }
            self.map.addSubview(userLocationImage);
        } else {
            if hasLocatedClient == false {
                hasLocatedClient = true
                self.currentClientLocation = cmxClientLocation
                
                // Add the activity indicator to the sub view
                self.view.addSubview(activityIndicator);
                
                // Remove all subviews for the map scroll view
                if self.cmxMapScrollView.subviews.count > 0 {
                    for subview in self.cmxMapScrollView.subviews {
                        subview.removeFromSuperview();
                    }
                }
                
                // Set the activity indicator and start the animation
                activityIndicator.frame = CGRect(x: (self.view.frame.width/2)-25, y: (self.view.frame.height/2)-25, width: 50, height: 50);
                activityIndicator.startAnimating();
                
            }
        }
    }
    
    func notificationUpdate(_ message: String, _ poi: DnaPointOfInterest?) {
    }
}
