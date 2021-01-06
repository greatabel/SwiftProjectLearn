import UIKit
import MapKit
import CoreData
import CoreLocation
import SystemConfiguration

var tappedArt = [Artworks]()
//var artInCell = [Artworks]()

//the main viewController for the map
class ViewController: UIViewController,
    UITableViewDelegate,UITableViewDataSource,
MKMapViewDelegate,CLLocationManagerDelegate{
    
    
    //this is for grouping the building together
    struct Building{
        
        var buildingName :String!
        var artWorksInSide = [Artworks]()
        var distanceToCurr: Double!
    }
    
    //building group easy for make the data into different based on the building
    var buildingGroup = [Building]()
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    //this part of code is been provided by Phill Jimmieson
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        //zoom in the map on the location
        let span:MKCoordinateSpan
            = MKCoordinateSpan(latitudeDelta: 0.002,longitudeDelta: 0.002)
        let myLocation:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(location.coordinate.latitude,
                                         location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        //resort the location array
        sortBuildingInSection(userLcation: location)
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBuildingInSection();
        //reset the cell height
        //table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        //create different class instance
        
        //locate the current the location of user
        if(CLLocationManager.locationServicesEnabled()){
            manager.delegate = self
            //set the accurat data that where the user is
            manager.desiredAccuracy = kCLLocationAccuracyBest
            //request the user Authorization when user is using the App
            manager.requestWhenInUseAuthorization()
            //every time the location is updated.
            manager.startUpdatingLocation()
           
           
        }
        
        
        
        mapView.showsScale = true
        
        //add the annotation when this page is been loaded
        addAnnotations()
        //reload all the table and map
        self.table.reloadData()
        //self.mapView.reloadInputViews()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        //remove all the elements in the tapped art when view is loaded
        tappedArt.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadBuildingInSection(){
        //first find all the buildings and put them in an array
        if (searchResult.isEmpty == false){
            
            var buildingNameArr = [String]();
            for object in searchResult {
                if(object.enabled == "1"){
                    //if the location is not contained in the array
                    if(!buildingNameArr.contains(object.location!)){
                        buildingNameArr.append(object.location!)
                    }
                }
            }
            
            //second separate the artwork array based on their building
            for name in buildingNameArr {
                //put the artwork with same name into same array
                var building = Building();
                building.buildingName = name
                
                //if the name of the search result match the name in the
                //name array then put them together
                for item in searchResult {
                    if(name == item.location && item.enabled == "1"){
                        building.artWorksInSide.append(item)
                    }
                }
                buildingGroup.append(building)
            }
            print("number of building in  buildingGroup \(buildingGroup.count)")
        }
    }
    
    //sort the building by distance
    func sortBuildingInSection(userLcation:CLLocation){
        
        if buildingGroup.count != 0{
            
            for (i,_) in buildingGroup.enumerated(){
                
                //add the distance to the instance in array buildingGroup
                for (j,_) in buildingGroup[i].artWorksInSide.enumerated(){
                    let obj = buildingGroup[i].artWorksInSide[j]
                    let objCoordinate = CLLocation(latitude: obj.lat,
                                                   longitude: obj.long)
                    let distanceBetween = userLcation.distance(from: objCoordinate)
                    //set these two distance
                    buildingGroup[i].artWorksInSide[j].distance
                        = distanceBetween
                    buildingGroup[i].distanceToCurr = distanceBetween
                    
                }
                //swift closure used to sort artwork by the distance
                buildingGroup[i].artWorksInSide.sort{ $0.distance < $1.distance}
            }
            //swift closure used to sort put the buildingGroup by the distance
            buildingGroup.sort{ $0.distanceToCurr < $1.distanceToCurr}
            
        }
        table.reloadData()
        
    }
    
    //add the other annotations and calculate the distance
    func addAnnotations(){
        
        if (searchResult.isEmpty == false){
            //print("data amount is \(searchResult.count as Any)")
            for object in searchResult {
                
                
                
                let annotation:MKPointAnnotation = MKPointAnnotation()
                let location = CLLocationCoordinate2D(latitude: object.lat,
                                                      longitude: object.long)
                annotation.coordinate = location
                annotation.title = object.title
                annotation.subtitle = object.location
                mapView.addAnnotation(annotation)
            }
            print("adding in anotation finished 😄")
            self.table.reloadData()
        }
    }
    
    //__________________________________________________________________________
    //                           table view part
    //__________________________________________________________________________
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //And also the cellForRowAt method, to return the data from the name bit
        //of the dictionary entry for this place (if it isn’t somehow nil).
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath) as! viewControllerTableViewCell
        // Configure the cell... enable attribute should be ckecked here
        if (buildingGroup.count > 0){
            let artInstance = buildingGroup[indexPath.section].artWorksInSide[indexPath.row]
            
            let text = """
            Title: \(artInstance.title!) \n
            Artist: \(artInstance.artist!) \n
            """
            let data = artInstance.imageData
            let img = UIImage(data:data! as Data)
            
            cell.myTextView.text = text
            cell.myImage.image = img
            
            //cell.textLabel?.text = artInstance.location
        }
        return cell
    }
    
    // count the object in the each of the section return the
    //value accordingly
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildingGroup[section].artWorksInSide.count
    }
    
    //how many section we have
    func numberOfSections(in tableView: UITableView) -> Int {
        return buildingGroup.count
    }
    
    //table view for group the build into together
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "System", size: 15)
        headerLabel.textColor = UIColor.white
        headerLabel.text = buildingGroup[section].buildingName
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    //height for each header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell number: \(indexPath.row)!")
        //add the cooresponding item in the array
        tappedArt.append(buildingGroup[indexPath.section].artWorksInSide[indexPath.row])
        let loginVC =
            UIStoryboard(name: "Main",
                         bundle: nil).instantiateViewController(
                            withIdentifier: "detailViewController") as! detailViewController
        self.present(loginVC, animated: true, completion: nil)
        
    }
    //__________________________________________________________________________
    //                           map view part
    //__________________________________________________________________________
    
    //when app update the map the image will cache itself
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AnnotationIdentifier"
        if annotation is MKUserLocation { return nil }
        
        
        var annotationView =
            mapView.dequeueReusableAnnotationView(withIdentifier:
                annotationIdentifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView =
                MKMarkerAnnotationView(annotation: annotation,
                                       reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            //put the rightCalloutAccessoryView as a information dot
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
            
            //put the image in the leftCalloutAccessory
            if (searchResult.isEmpty == false){
                for object in searchResult {
                    
                    if (object.title! == annotation.title!){
                        
                        
                        let data = object.imageData
                        //set up the image for the annotation
                        if(data != nil){
                            //set up the image size
                            let imageView
                                = UIImageView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: annotationView!.frame.width ,
                                                            height: annotationView!.frame.height))
                            imageView.image = UIImage(data:data! as Data)
                            imageView.contentMode = .scaleAspectFit
                            annotationView!.leftCalloutAccessoryView = imageView
                            
                        }
                    }
                }
            }
            //new feature from WWDC 2017
            annotationView?.glyphText = "😎"
            annotationView?.markerTintColor = UIColor.black
            
        }else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    //detect the button press in the callputView
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            //when tapping the annotaion check how many artwork are in the
            //same building
           // print("button tapped in \(String(describing: view.annotation?.subtitle))")
            for item in searchResult{
                if item.location ==
                    (view.annotation?.subtitle)! {
                    tappedArt.append(item)
                }
            }
            
            let loginVC =
                UIStoryboard(name: "Main",
                             bundle: nil).instantiateViewController(
                                withIdentifier: "detailViewController") as! detailViewController
            self.present(loginVC, animated: true, completion: nil)
        }
        
        
    }
    
    
}


