import UIKit

//this view shows the detail of the artwork
class detailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //tables and bar button
//    @IBOutlet weak var buildTitle: UIBarButtonItem!
  
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var ByLbl: UILabel!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.title = tappedArt[0].location
        ByLbl.text = "By " + tappedArt[0].artist!
//        navigationItem.title = "Title"
//        let buildTitle = UIBarButtonItem()

        //set the title for the bar at the buttom
//        buildTitle.title = tappedArt[0].location
//        //set the width of the bar maximum
//        buildTitle.width = -5
//        buildTitle.tintColor = UIColor.black
//        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//         negativeSpacer.width = 350
//
//         self.navigationItem.rightBarButtonItems = [negativeSpacer,buildTitle]
        
        table.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    
    //return the cell number depends on the number of artwork been selected
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return places.count
        return tappedArt.count
    }
    
    //return the cell based on the indexPath
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //And also the cellForRowAt method, to return the data from the name bit
        //of the dictionary entry for this place (if it isn’t somehow nil).
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
            as UITableViewCell
        // Configure the cell...
        let imageView = cell.viewWithTag(1) as! UIImageView
        let textView = cell.viewWithTag(2) as! UITextView
        
        let artInstance = tappedArt[indexPath.row]
        let data = artInstance.imageData
        let img = UIImage(data:data! as Data)
        
        //set the image and inofrmation thatn
        imageView.image = img
        let heading = """
        \(artInstance.title ?? "Non")
        """
        
        let made_year = """
        
        Maded in: \(artInstance.yearOfWork ?? "Non")
        \n
        """
        let content = """
        \(artInstance.information ?? "Non")
        ID: \(artInstance.id)
        locationNotes: \(artInstance.locationNotes ?? "Non")
        last update time: \(artInstance.lastModified ?? "Non")
        """

        let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])

        attributedText.append(NSAttributedString(string: made_year, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.gray]))

        
        attributedText.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black]))

        textView.attributedText = attributedText

//        textView.text = """
//
//        \(artInstance.title ?? "Non")
//        \n
//        Maded in: \(artInstance.yearOfWork ?? "Non")
//        \n
//        \(artInstance.information ?? "Non")
//        \n
//        ID: \(artInstance.id)
//        locationNotes: \(artInstance.locationNotes ?? "Non")
//        last update time: \(artInstance.lastModified ?? "Non")
//        """
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //go back function for dismissing current view
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
