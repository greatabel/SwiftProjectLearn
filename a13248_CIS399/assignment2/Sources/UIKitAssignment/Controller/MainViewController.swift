import UIKit

class MainViewController: UIViewController, DetailViewControllerDelegate {
    
    @IBOutlet weak var LblCount: UILabel!
    
    static var presentedCount = 0
    static func incrementalCount() ->Int{
        presentedCount += 1
        return presentedCount
    }
    
    func detailViewControllerDidPerformAction(sender: DetailViewController) {
        print("detailViewControllerDidPerformAction in Main")
        let mycount = MainViewController.incrementalCount()
        if mycount == 1 {
            LblCount.text = "The detail action has been performed \(mycount) time"
        } else {
            LblCount.text = "The detail action has been performed \(mycount) times"
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoDetail"{
            let detailViewController = segue.destination as! DetailViewController
         
            detailViewController.delegate = self
        }
        
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
     
    }
}
