import UIKit


class ViewController: UIViewController {
 
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var resumeBtn: UIButton!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBAction func start_click(_ sender: Any) {
        startBtn.isHidden = true
        saveBtn.isHidden = false
        resumeBtn.isHidden = false
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
//        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.eachSecond()
        }
    }
    
    @IBAction func save_click(_ sender: Any) {
        
    }
    
    @IBAction func resume_click(_ sender: Any) {
        
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


