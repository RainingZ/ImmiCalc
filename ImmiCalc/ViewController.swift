//
//  ViewController.swift
//  ImmiCalc
//
//  Created by Raining on 2017-05-19.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit
var pr_citi_flag:Int = 0
class ViewController: UIViewController {
    @IBOutlet weak var pr_button: UIButton!
    @IBOutlet weak var citi_button: UIButton!
    
    @IBAction func Citi_button_pressed(_ sender: UIButton) {
        pr_citi_flag = 1
    }
    @IBAction func PR_button_pressed(_ sender: UIButton) {
        pr_citi_flag = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pr_button.layer.cornerRadius = 10
        pr_button.layer.borderWidth = 0
        citi_button.layer.cornerRadius = 10
        citi_button.layer.borderWidth = 0
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

