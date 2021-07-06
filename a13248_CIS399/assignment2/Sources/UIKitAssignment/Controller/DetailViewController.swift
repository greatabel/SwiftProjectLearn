import UIKit

class DetailViewController: UIViewController {

    
    weak var delegate:DetailViewControllerDelegate?
    
    @IBAction func clickAction(_ sender: Any) {
        
        delegate?.detailViewControllerDidPerformAction(sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        

        presentedLabel.text = "Presented on \(dateString) times"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    @IBOutlet weak var presentedLabel: UILabel!
    

}


