//
//  ViewController.swift
//  RunningApp
//
//  Created by estedu6 theodore on 29/09/2020.
//  Copyright © 2020 estedu6 theodore. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var time = Timer()
    var sec = 0
    var min = 0
    var hr = 0
    
    @IBOutlet weak var lable: UILabel!
    
    
    func setView(view: UIView, hidden: Bool){
        UIView.transition(with: view, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            view.isHidden = hidden
        })
    }
    
    @IBOutlet weak var buttonStart: UIButton!
    
    @IBOutlet weak var buttonSave: UIButton!
    
    @IBOutlet weak var buttonResume: UIButton!
    
    @IBOutlet weak var buttonPause: UIButton!
    
    @IBAction func start(_ sender: Any) {
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
        setView(view: buttonStart, hidden: true)
        setView(view: buttonPause, hidden: false)
        
    }
    
    @IBAction func clickPause(_ sender: UIButton) {
        setView(view: buttonPause, hidden: true)
        setView(view: buttonSave, hidden: false)
        setView(view: buttonResume, hidden: false)
        time.invalidate()
    }
    
    @IBAction func clickSAVE(_ sender: UIButton) {
        setView(view: buttonStart, hidden: false)
        setView(view: buttonSave, hidden: true)
        setView(view: buttonResume, hidden: true)
        // more code
        time.invalidate()
        sec = 0
        min = 0
        hr = 0
        lable.text = String(sec) + ":" + String(min) + ":" + String(hr)
    }
    
    
     @IBAction func clickRESUME(_ sender: UIButton) {
        setView(view: buttonPause, hidden: false)
        setView(view: buttonSave, hidden: true)
        setView(view: buttonResume, hidden: true)
      time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
    }
    
    
    @objc func action(){
        sec += 1
        if(sec == 60){
            sec = 0
            min += 1
            if(min == 60){
                min = 0
                hr += 1
            }
        }
        
        lable.text = String(sec) + ":" + String(min) + ":" + String(hr)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


