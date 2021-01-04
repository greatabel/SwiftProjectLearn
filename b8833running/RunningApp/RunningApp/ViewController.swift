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
    
    var myruns: [NSManagedObject] = []
    
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
    }
    
    @IBAction func resume_click(_ sender: Any) {
        loadData()
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
    }
    private func saveRun(){
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.endTime = Date()
        newRun.startTime = Date(milliseconds: (newRun.endTime!.millisecondsSince1970 - Int64(seconds)))
        
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
    
    private func loadData(){
    
        
        let managedContext =
            CoreDataStack.context
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Run")
        
        //3
        do {
            myruns = try managedContext.fetch(fetchRequest)
            print(myruns)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
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


