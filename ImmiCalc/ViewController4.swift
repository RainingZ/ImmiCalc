//
//  ViewController4.swift
//  ImmiCalc
//
//  Created by Raining on 2017-07-10.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class ViewController4: UIViewController {

    @IBOutlet weak var perm_citi_label: UILabel!
    @IBOutlet weak var more_label: UILabel!
    @IBOutlet weak var away_label: UILabel!
    @IBOutlet weak var stayed_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign background image
        assignBackground(VC: self,name: "iPhone-Maple1.jpg")
        
        perm_citi_label.layer.masksToBounds = true
        perm_citi_label.layer.cornerRadius = 5
        perm_citi_label.layer.borderWidth = 0
        if (vars.pr_citi_flag == 0) {
            perm_citi_label.addConstraint(NSLayoutConstraint(item: perm_citi_label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
            perm_citi_label.text = "Permanent Resident"
        }
        else {
            perm_citi_label.addConstraint(NSLayoutConstraint(item: perm_citi_label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
            perm_citi_label.text = "Citizen"
        }
        more_label.layer.masksToBounds = true
        more_label.layer.cornerRadius = 5
        more_label.layer.borderWidth = 0
        away_label.layer.masksToBounds = true
        away_label.layer.cornerRadius = 5
        away_label.layer.borderWidth = 0
        stayed_label.layer.masksToBounds = true
        stayed_label.layer.cornerRadius = 5
        stayed_label.layer.borderWidth = 0
        
        // Main Calculation
        if (vars.dates.count != 0) {
            for i in 0...(vars.dates.count-1) {
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
