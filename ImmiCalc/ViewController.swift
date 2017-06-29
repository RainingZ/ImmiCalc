//
//  ViewController.swift
//  ImmiCalc
//
//  Created by Raining on 2017-05-19.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit
import DatePickerCell

// Global variables
struct vars {
    static let formatter = DateFormatter()
    static var pr_citi_flag:Int = 0
    static var land_date = Date()
    static var expand_height:CGFloat = 0
    static var dates:NSArray = []
    static var from_date = Date()
    static var to_date = Date()
    //DatePickerCells
    static let datePickerCell = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    static let datePickerCell2 = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    //Notification
    static let AddButtonNotification = Notification.Name("AddButtonNotification")
}

class ViewController: UIViewController {
    @IBOutlet weak var pr_button: UIButton!
    @IBOutlet weak var citi_button: UIButton!
    
    // Set pr_citi_flag
    @IBAction func Citi_button_pressed(_ sender: UIButton) {
        vars.pr_citi_flag = 1
    }
    @IBAction func PR_button_pressed(_ sender: UIButton) {
        vars.pr_citi_flag = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the navigation bar on the first page
        self.navigationController?.isNavigationBarHidden = true
        
        // Make rounded corners for buttons
        pr_button.layer.cornerRadius = 10
        pr_button.layer.borderWidth = 0
        citi_button.layer.cornerRadius = 10
        citi_button.layer.borderWidth = 0
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Hide the navigation bar on the first page
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

