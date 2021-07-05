import UIKit

class DetailViewController: UIViewController {
    static var presentedCount = 0
    
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
    
    static func incrementalCount() ->Int{
        presentedCount += 1
        return presentedCount
    }
    @IBOutlet weak var presentedLabel: UILabel!
}
