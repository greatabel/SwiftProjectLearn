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
    
    @IBOutlet weak var txtInput: UITextField!
    
    @IBAction func btn_search(_ sender: Any) {
        let movie_name = txtInput.text
        if movie_name != nil {
            
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
