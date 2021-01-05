import UIKit
import MapKit

//MapViewController

/*
 how to test without cityrun
 https://juejin.cn/post/6844904180742619143
 */

class MulticolorPolyline: MKPolyline {
  var color = UIColor.black
}

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
   
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  
  var run: Run!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  override func viewDidAppear(_ animated: Bool) {
    print("viewDidAppear in MapV")
    configureView()
    }
/*
pin Pins on the maps, use start , end lat-long cordinate use its position
*/
func placePins() {
    for annotation in mapView.annotations{
        mapView.removeAnnotation(annotation)
    }
    var  myruns = CoreDataStack.loadData()
    if (myruns.count > 0 && run.locations!.count > 0) {
        //    let coords = [CLLocationCoordinate2D(latitude: 40.689249, longitude: -74.044500), CLLocationCoordinate2D(latitude: 40.781174, longitude: -73.966660), CLLocationCoordinate2D(latitude: 40.748817, longitude: -73.985428), CLLocationCoordinate2D(latitude: 40.706175, longitude: -73.996918)]
            let locations = run.locations?.array as! [Location]
            let start = CLLocationCoordinate2D(latitude: locations[0].latitude,
                                               longitude: locations[0].longitude)
            let end = CLLocationCoordinate2D(latitude: locations[locations.count-1].latitude,
                                               longitude: locations[locations.count-1].longitude)
            let coords = [start, end]
            
            let titles = ["Start", "Finish"]
            for i in coords.indices {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coords[i]
                annotation.title = titles[i]
                mapView.addAnnotation(annotation)
            }
    }

}
  
  private func configureView() {
//    let distance = Measurement(value: run.distance, unit: UnitLength.meters)
//    let seconds = Int(run.duration)
//    let formattedDistance = FormatDisplay.distance(distance)
//    let formattedDate = FormatDisplay.date(run.timestamp)
//    let formattedTime = FormatDisplay.time(seconds)
//    let formattedPace = FormatDisplay.pace(distance: distance,
//                                           seconds: seconds,
//                                           outputUnit: UnitSpeed.minutesPerMile)
    
//    distanceLabel.text = "Distance:  \(formattedDistance)"
//    dateLabel.text = formattedDate
//    timeLabel.text = "Time:  \(formattedTime)"
//    paceLabel.text = "Pace:  \(formattedPace)"
    
    loadMap()
    placePins()
  }
  
  private func mapRegion() -> MKCoordinateRegion? {
    var  myruns = CoreDataStack.loadData()
    if myruns.count > 0 {
        run = myruns[myruns.count-1] as! Run
    }
    guard
      let locations = run.locations,
      locations.count > 0
    else {
      return nil
    }
    
    let latitudes = locations.map { location -> Double in
      let location = location as! Location
      return location.latitude
    }
    
    let longitudes = locations.map { location -> Double in
      let location = location as! Location
      return location.longitude
    }
    
    let maxLat = latitudes.max()!
    let minLat = latitudes.min()!
    let maxLong = longitudes.max()!
    let minLong = longitudes.min()!
    
    let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                        longitude: (minLong + maxLong) / 2)
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                longitudeDelta: (maxLong - minLong) * 1.3)
    return MKCoordinateRegion(center: center, span: span)
  }
  
  private func polyLine() -> [MulticolorPolyline] {
    
    // 1
    let locations = run.locations?.array as! [Location]
    var coordinates: [(CLLocation, CLLocation)] = []
    var speeds: [Double] = []
    var minSpeed = Double.greatestFiniteMagnitude
    var maxSpeed = 0.0
    
    // 2
    for (first, second) in zip(locations, locations.dropFirst()) {
      let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
      let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
      coordinates.append((start, end))
      
      //3
      let distance = end.distance(from: start)
      print("###distance=\(distance)")
      let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
      let speed = time > 0 ? distance / time : 0
      speeds.append(speed)
      minSpeed = min(minSpeed, speed)
      maxSpeed = max(maxSpeed, speed)
    }

    var segments: [MulticolorPolyline] = []
    for (start, end)in coordinates {
      let coords = [start.coordinate, end.coordinate]
      let segment = MulticolorPolyline(coordinates: coords, count: 2)

      segment.color = UIColor.red
      segments.append(segment)
    }
    return segments
  }
  
  private func loadMap() {
    var  myruns = CoreDataStack.loadData()
    if myruns.count > 0 {
        run = myruns[myruns.count-1] as! Run
        
        guard
          let locations = run.locations,
          locations.count > 0,
          let region = mapRegion()
        else {
            let alert = UIAlertController(title: "Error",
                                          message: "Sorry, this run has no locations saved",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlays(polyLine())
    }
    

  }
  
  private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
    enum BaseColors {
      static let r_red: CGFloat = 1
      static let r_green: CGFloat = 20 / 255
      static let r_blue: CGFloat = 44 / 255
      
      static let y_red: CGFloat = 1
      static let y_green: CGFloat = 215 / 255
      static let y_blue: CGFloat = 0
      
      static let g_red: CGFloat = 0
      static let g_green: CGFloat = 146 / 255
      static let g_blue: CGFloat = 78 / 255
    }
    
    let red, green, blue: CGFloat
    
    if speed < midSpeed {
      let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
      red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
      green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
      blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
    } else {
      let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
      red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
      green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
      blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
    }
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }
}

// MARK: - Map View Delegate

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MulticolorPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = polyline.color
    renderer.lineWidth = 3
    return renderer
  }
}
