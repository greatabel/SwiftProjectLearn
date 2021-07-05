import UIKit

class MainViewController: UIViewController, sendingInformation {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let message = "Deliver message successfully"
    
    func modalViewControllerDidSelectDone(_ modalViewController: ModalViewController) {
        dismiss(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoSegue"{
            let navigationController = segue.destination as! UINavigationController
            let modalViewController: ModalViewController = navigationController.topViewController as! ModalViewController
            modalViewController.delegate = self
        }
    }
}
