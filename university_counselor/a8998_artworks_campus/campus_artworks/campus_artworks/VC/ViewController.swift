import UIKit
import MapKit
import CoreData
import CoreLocation
import SystemConfiguration

var tappedArt = [Artworks]()

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
    override var prefersStatusBarHidden:Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        self.navigationController?.toolbar.isHidden = true
//        view.insetsLayoutMarginsFromSafeArea = false
 
        
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
            print("adding in anotation finished")
            self.table.reloadData()
        }
    }
    
    //**************************************************************************
    //                           table view place/artwork list part
    //**************************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //And also the cellForRowAt method, to return the data from the name bit
        //of the dictionary entry for this place (if it isn’t somehow nil).
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath) as! viewControllerTableViewCell
        // add > to right
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        // Configure the cell... enable attribute should be ckecked here
        if (buildingGroup.count > 0){
            let artInstance = buildingGroup[indexPath.section].artWorksInSide[indexPath.row]
            
            // https://stackoverflow.com/questions/58951570/how-to-add-two-different-font-size-to-textview-text-in-swift
            
            let heading = "\(artInstance.title!)\n\n"
            let content = "\(artInstance.artist!) \n"

            let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)])

            attributedText.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))

            cell.myTextView.attributedText = attributedText
            

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
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        headerLabel.textColor = UIColor.black
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
        tappedArt.removeAll()
        tappedArt.append(buildingGroup[indexPath.section].artWorksInSide[indexPath.row])
        let detailVC =
            UIStoryboard(name: "Main",
                         bundle: nil).instantiateViewController(
                            withIdentifier: "detailViewController") as! detailViewController
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
//        performSegue(withIdentifier: "show_detail", sender: self)
//        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }

    
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
            let myButton = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
            myButton.backgroundColor = UIColor.gray
            myButton.setTitle(">", for: .normal)
            annotationView?.rightCalloutAccessoryView = myButton
            
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
                    tappedArt.removeAll()
                    tappedArt.append(item)
                }
            }
            

            let detailVC =
                UIStoryboard(name: "Main",
                             bundle: nil).instantiateViewController(
                                withIdentifier: "detailViewController") as! detailViewController
            detailVC.modalPresentationStyle = .fullScreen
            self.present(detailVC, animated: true, completion: nil)
        }
        
        
    }
    
    
}


