import UIKit
import CoreLocation
import CoreData

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

class LocationManager {
  static let shared = CLLocationManager()
  
  private init() { }
}

class ViewController: UIViewController {
    
    private var run: Run?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var resumeBtn: UIButton!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBAction func start_click(_ sender: Any) {
        startRun()
    }
    
    @IBAction func save_click(_ sender: Any) {
        saveRun()
        
        
        startBtn.isHidden = false
        saveBtn.isHidden = true
        
        
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func resume_click(_ sender: Any) {
//        loadData()
    }
    
    private func startLocationUpdates() {
      locationManager.delegate = self
      locationManager.activityType = .fitness
      locationManager.distanceFilter = 10
      locationManager.startUpdatingLocation()
    }
    
    private func startRun() {
        startBtn.isHidden = true
        saveBtn.isHidden = false
        resumeBtn.isHidden = false
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.eachSecond()
        }
        startLocationUpdates()
    }
    private func saveRun(){
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.endTime = Date()
        newRun.startTime = Date(milliseconds: (newRun.endTime!.millisecondsSince1970 - Int64(seconds)))
        print("in saveRun :\(locationList.count)")
        for location in locationList {
          let locationObject = Location(context: CoreDataStack.context)
          locationObject.timestamp = location.timestamp
          locationObject.latitude = location.coordinate.latitude
          locationObject.longitude = location.coordinate.longitude
          newRun.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        
        run = newRun
    }
    
    private func stopRun(){
        saveRun()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveBtn.isHidden = true
        resumeBtn.isHidden = true
    }
    
    func eachSecond() {
      seconds += 1
      updateDisplay()
    }
    
    private func updateDisplay() {
      let formattedDistance = FormatDisplay.distance(distance)
      let formattedTime = FormatDisplay.time(seconds)
//      let formattedPace = FormatDisplay.pace(distance: distance,
//                                             seconds: seconds,
//                                             outputUnit: UnitSpeed.minutesPerMile)
      
        lblDistance.text = "Distance:  \(formattedDistance)"
        lblTime.text = "Time:  \(formattedTime)"
//      paceLabel.text = "Pace:  \(formattedPace)"
    }


}

extension ViewController: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager authorization status change")
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        print("update here")
        for newLocation in locations {
          let howRecent = newLocation.timestamp.timeIntervalSinceNow
    //      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
          print("\(abs(howRecent)) here")
          if let lastLocation = locationList.last {
            let delta = newLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
    //        let coordinates = [lastLocation.coordinate, newLocation.coordinate]
    //        mapView.add(MKPolyline(coordinates: coordinates, count: 2))
    //        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
    //        mapView.setRegion(region, animated: true)
          }
          
          locationList.append(newLocation)
          print("new Location:\(newLocation)")
        }
    }
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
      
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }

}

