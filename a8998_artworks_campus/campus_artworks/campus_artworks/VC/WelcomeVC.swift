import UIKit
import CoreData
import SystemConfiguration


public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}

//this view will give a user prompt for internet availity
class WelcomeVC: UIViewController {

    //view did load execute when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func enter_action(_ sender: Any) {

        let mainVC =
            UIStoryboard(name: "Main",
                         bundle: nil).instantiateViewController(
                            withIdentifier: "mainVC") as! ViewController
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
    @IBOutlet weak var enterBtn: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var intFlag = false
        
        if Reachability.isConnectedToNetwork(){
            presentInternetAlert(title: "Welcome to use",
                                 message: "Network available to async data")
           //set the internet flag equals to true
            intFlag = true
        }else{
            presentInternetAlert(title: "No Internet!",
                                 message: "Data are previous data")
            //inter net flag equals to false
            intFlag = false
        }
        
        //load the data from the core data whether it will updata or fetch
        //online depends on the internet connectivity.
        let loadDataInstance = LoadData()
        loadDataInstance.loadJsonData(flag: intFlag)
        

    }
    
    //function for present the alet message box
    func presentInternetAlert(title:String,message:String){
        // create the alert
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
