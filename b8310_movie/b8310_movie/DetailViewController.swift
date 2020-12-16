//
//  DetailViewController.swift
//  b8310_movie
//
//  Created by abel on 2020/12/16.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var ret: String = "app loaded";
    @IBOutlet weak var txtInput: UITextField!
    
    @IBOutlet weak var lbl_year: UILabel!
    
    @IBOutlet weak var lbl_ID: UILabel!
    
    @IBOutlet weak var lbl_plot: UILabel!
    
    @IBAction func btn_search(_ sender: Any) {
        var movie_name: String = ""
        movie_name = txtInput.text!
        if movie_name != "" {
            do {

//                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted);

                    let url = URL(string: "http://www.omdbapi.com/?t="+movie_name+"&apikey=mohawk")!
                    var request = URLRequest(url: url);

                    request.httpMethod = "GET";
                    request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type");
//                    request.httpBody = jsonData;

                    let task = URLSession.shared.dataTask(with: request) {
                        data, response, error in
                        if error != nil {
                            print("Error -> \(String(describing: error))");
                            self.ret = "\(String(describing: error))";
                        }
                        if let httpResponse = response as? HTTPURLResponse {
                            print("statusCode: \(httpResponse.statusCode)");
                            if(httpResponse.statusCode == 200) {
//                                self.ret = "success \(httpResponse.statusCode)"
                                if let jsonResponse = String(data: data!, encoding: String.Encoding.utf8) {
//                                    print("JSON String: \(jsonResponse)")
                                    do {
                                               if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                                                    
                                                    // Print out entire dictionary
                                                    print(convertedJsonIntoDict)
                                                    
                                                    // Get value by key
                                                    let year = convertedJsonIntoDict["Year"]
                                                    print(year ?? "userId could not be read")
                                                self.ret = year as! String
                                                    self.doLabelChange()
                                                    
                                                }
                                     } catch let error as NSError {
                                                print(error.localizedDescription)
                                      }

                                }
                            } else {
                                self.ret = "error \(httpResponse.statusCode)"
                            }
                        }
                    }

                    task.resume();
                } catch {
                    print(error);
                }
        }
    }
    
    func doLabelChange() {
        DispatchQueue.main.async {
               self.lbl_year.text = self.ret
            }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
