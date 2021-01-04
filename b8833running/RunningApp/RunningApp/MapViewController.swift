import UIKit
import CoreLocation
import MapKit
import CoreData

class MulticolorPolyline: MKPolyline {
  var color = UIColor.red
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

class MapViewController: UIViewController {
    var run: Run!
    var myruns1: [NSManagedObject] = []
     
    @IBOutlet weak var mapView: MKMapView!
    
//    let locationManager = CLLocationManager()
    private func mapRegion() -> MKCoordinateRegion? {
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
        print(first.latitude,first.longitude, second.latitude,second.longitude)
        let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
        let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
        coordinates.append((start, end))
        
        //3
        let distance = end.distance(from: start)
        print("#distance=\(distance)")
        let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
        let speed = time > 0 ? distance / time : 0
        speeds.append(speed)
        minSpeed = min(minSpeed, speed)
        maxSpeed = max(maxSpeed, speed)
      }
      
      //4
      let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
      
      //5
      var segments: [MulticolorPolyline] = []
      for ((start, end), speed) in zip(coordinates, speeds) {
        let coords = [start.coordinate, end.coordinate]
        let segment = MulticolorPolyline(coordinates: coords, count: 2)
//        segment.color = segmentColor(speed: speed,
//                                     midSpeed: midSpeed,
//                                     slowestSpeed: minSpeed,
//                                     fastestSpeed: maxSpeed)
        segment.color = UIColor.red
        segments.append(segment)
      }
      return segments
    }
    
    
    private func loadMap() {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("v3 load")
        myruns1 = CoreDataStack.loadData()
        
        if (myruns1.count > 0) {
            print("here3 \(myruns1.count)")
            run = myruns1[myruns1.count-1] as! Run
            print("here3.1")
            print(run.locations?.count)
            print("## \(run.locations)")
            loadMap()
        }
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest

//        retriveCurrentLocation()
    }
    
    
//    func retriveCurrentLocation(){
//        let status = CLLocationManager.authorizationStatus()
//
//        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
//            // show alert to user telling them they need to allow location data to use some feature of your app
//            return
//        }
//
//        // if haven't show location permission dialog before, show it to user
//        if(status == .notDetermined){
//            locationManager.requestWhenInUseAuthorization()
//
//            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
//            // locationManager.requestAlwaysAuthorization()
//            return
//        }
//
//        // at this point the authorization status is authorized
//        // request location data once
//       // locationManager.requestLocation()
//        locationManager.startUpdatingLocation()
//
//        // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
//        // locationManager.startUpdatingLocation()
//    }
    
//    func updateMap(with coordinate: CLLocationCoordinate2D) {
//
//        let coordinateRegion = MKCoordinateRegion(center: coordinate,
//                                                    latitudinalMeters: 1000, longitudinalMeters: 1000)
//        mapView.setRegion(coordinateRegion, animated: true)
//        //let annotation = Annotation(title: "You are here", locationName: "Here", coordinate: coordinate)
//      //  mapView.addAnnotation(annotation)
//
//    }
//
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MulticolorPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
//    renderer.strokeColor = polyline.color
    renderer.strokeColor = UIColor.red
    renderer.lineWidth = 3
    return renderer
  }
}


//extension MapViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Location manager authorization status change")
//        switch status {
//        case .authorizedAlways:
//            print("user allow app to get location data when app is active or in background")
//        case .authorizedWhenInUse:
//            print("user allow app to get location data only when app is active")
//        case .denied:
//            print("user tap 'disallow' on the permission dialog, cant get location data")
//        case .restricted:
//            print("parental control setting disallow location data")
//        case .notDetermined:
//            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
//        }
//
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // .requestLocation will only pass one location to the locations array
//        // hence we can access it by taking the first element of the array
//        print("update")
//        if let location = locations.last {
//            print("\(location.coordinate.latitude)")
//            print("\(location.coordinate.longitude)")
//            updateMap(with: location.coordinate)
//
//
//        }
//    }
//
//
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            // might be that user didn't enable location service on the device
//            // or there might be no GPS signal inside a building
//
//            // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
//        }
//
//    }
//
