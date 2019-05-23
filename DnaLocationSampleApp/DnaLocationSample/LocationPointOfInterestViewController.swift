import UIKit
import DnaLocation

class LocationPointsOfInterestViewController: UITableViewController {
    
    @IBOutlet weak var cmxTextView: UITextView!
    var hasDisplayedPois: Bool!
    
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
        self.cmxTextView!.text.removeAll()
        self.hasDisplayedPois = false
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
        if cmxLocation != nil && !self.hasDisplayedPois {
            self.hasDisplayedPois = true
            DnaLocationClient.getPointsOfInterest(onCompletion: self.onCompletionOfGetPois)
        }
    }
    
    func onCompletionOfGetPois(pois: [DnaPointOfInterest]?, error: Error?) {
        if pois != nil {
            for poi in pois! {
                self.cmxTextView.text.append(poi.name + "\n")
            }
        }
    }
    
    func notificationUpdate(_ message: String, _ poi: DnaPointOfInterest?) {
    }
}
