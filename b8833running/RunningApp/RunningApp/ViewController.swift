//
//  ViewController.swift
//  RunningApp
//
//  Created by estedu6 theodore on 29/09/2020.
//  Copyright © 2020 estedu6 theodore. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
 
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var resumeBtn: UIButton!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveBtn.isHidden = true
        resumeBtn.isHidden = true
    }


}


