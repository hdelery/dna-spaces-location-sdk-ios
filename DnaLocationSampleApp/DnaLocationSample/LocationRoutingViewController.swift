import UIKit
import DnaLocation

class LocationRoutingViewController: UITableViewController {
    
    @IBOutlet weak var cmxCurrentLocationLabel: UILabel!
    @IBOutlet weak var cmxCurrentLocationTimeLabel: UILabel!
    @IBOutlet weak var cmxTextView: UITextView!
    var hasStartedRoute: Bool!
    var routeControler: LocationRouteController = LocationRouteController()
    
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
        self.hasStartedRoute = false
        self.cmxTextView!.text.removeAll()
        DnaLocationClient.startLocationUpdates(onUpdate: self.clientLocationUpdate, onNotification: self.notificationUpdate)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DnaLocationClient.stopLocationUpdates()
    }
    
    func clientLocationUpdate(_ cmxLocation: DnaDeviceLocation?, _ error: Error?) {
        if (error != nil) {
            let alertController = UIAlertController(title: "Location Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        if cmxLocation != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.medium
            self.cmxCurrentLocationLabel.text = String(format: "(%.2f, %.2f)", cmxLocation!.floorCoordinate.x, cmxLocation!.floorCoordinate.y)
            let locatedTimeString = dateFormatter.string(from: (cmxLocation?.locatedTime)!)
            self.cmxCurrentLocationTimeLabel.text = locatedTimeString
            if !self.hasStartedRoute {
                self.hasStartedRoute = true
                let destinationPoi: DnaPointOfInterest = DnaPointOfInterest()
                let destinationPoint: DnaFloorCoordinate = DnaFloorCoordinate()
                //destinationPoint.floorId = (cmxLocation?.floorId)!
                destinationPoint.x = 450
                destinationPoint.y = 450
                destinationPoi.floorCoordinate = destinationPoint
                DnaLocationClient.startRoute(poi: destinationPoi, routeController: routeControler)
            }
        }
    }
    
    func notificationUpdate(_ message: String, _ poi: DnaPointOfInterest?) {
        self.cmxTextView!.text.append(message + "\n")
    }
}

class LocationRouteController: DnaRouteController {
    func onRouteCalculated(_ wayPoints: [DnaFloorCoordinate]?, _ error: Error?) {
        let window = UIApplication.shared.keyWindow
        let vc = window?.rootViewController
        let tabController: UITabBarController = vc as! UITabBarController
        let routeController: LocationRoutingViewController = tabController.selectedViewController as! LocationRoutingViewController
        routeController.cmxTextView!.text.append("Completed route calculation\n")
        for wayPoint in wayPoints! {
            routeController.cmxTextView.text.append("(\(wayPoint.x), \(wayPoint.y))\n")
        }
    }
    
    func onShouldReroute() {
        let window = UIApplication.shared.keyWindow
        let vc = window?.rootViewController
        let tabController: UITabBarController = vc as! UITabBarController
        let routeController: LocationRoutingViewController = tabController.selectedViewController as! LocationRoutingViewController
        routeController.cmxTextView!.text.append("Should reroute\n")
    }
    
    func onDestinationReached() {
        let window = UIApplication.shared.keyWindow
        let vc = window?.rootViewController
        let tabController: UITabBarController = vc as! UITabBarController
        let routeController: LocationRoutingViewController = tabController.selectedViewController as! LocationRoutingViewController
        routeController.cmxTextView!.text.append("Desination reached\n")
    }
}
