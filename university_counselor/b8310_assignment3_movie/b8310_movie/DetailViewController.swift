//
//  DetailViewController.swift
//  b8310_movie
//
//  Created by abel on 2020/12/16.
//

import UIKit

class DetailViewController: UIViewController {
    
    var photo: Photo! {
        didSet {
//            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        store.fetchImage(for: photo) { (result) -> Void in
//            switch result {
//            case let .success(image):
//                print(image)
//            case let .failure(error):
//                print("Error fetching image for photo: \(error)")
//            }
//        }
    }
    
    var year: String = "app loaded";
    var id: String = "app loaded";
    var plot: String = "app loaded";
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
//                            self.ret = "\(String(describing: error))";
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
                                                    let id = convertedJsonIntoDict["imdbID"]
                                                    let plot = convertedJsonIntoDict["Plot"]
                                                    let poster = convertedJsonIntoDict["Poster"]
                                                    print(year ?? "userId could not be read")
                                                    print(poster ?? "userId could not be read")
                                                    self.year = (year ?? "Not found") as! String
                                                    self.id = (id ?? "") as! String
                                                    self.plot = (plot ?? "") as! String
                                                    self.doLabelChange()
                                                    print("detail photoid=\(self.photo.photoID)")
                                                if poster != nil {
                                                    self.photo.remoteURL = URL(string: poster as! String) as NSObject?
                                                    self.store.UpdateImage(photo: self.photo)
                                                }


                                                   
                                                            
                                                }
                                     } catch let error as NSError {
                                                print(error.localizedDescription)
                                      }

                                }
                            } else {
//                                self.ret = "error \(httpResponse.statusCode)"
                            }
                        }
                    }

                    task.resume();
                }
        }
    }
    
    func doLabelChange() {
        DispatchQueue.main.async {
               self.lbl_year.text = self.year
               self.lbl_ID.text  = self.id
               self.lbl_plot.text = self.plot
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
