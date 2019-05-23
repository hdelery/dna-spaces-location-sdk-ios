import UIKit
import DnaLocation

class LocationMeasurementsViewController: UITableViewController {
    
    @IBOutlet weak var cmxCurrentLocationLabel: UILabel!
    @IBOutlet weak var cmxCurrentLocationTimeLabel: UILabel!
    @IBOutlet weak var cmxTextView: UITextView!
    
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
        cmxTextView!.text.removeAll()
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
            let locatedTimeString = dateFormatter.string(from: (cmxLocation?.locatedTime)!)
            self.cmxCurrentLocationTimeLabel.text = locatedTimeString
            self.cmxCurrentLocationLabel.text = String(format: "(%.2f, %.2f)", cmxLocation!.floorCoordinate.x, cmxLocation!.floorCoordinate.y)
        }
    }
    
    func notificationUpdate(_ message: String, _ poi: DnaPointOfInterest?) {
        cmxTextView!.text.append(message + "\n")
    }
}
