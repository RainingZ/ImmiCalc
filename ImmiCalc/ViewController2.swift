//
//  ViewController2.swift
//  ImmiCalc
//
//  Created by Raining on 2017-05-20.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var done_button: UIButton!
    @IBOutlet weak var land_label: UILabel!
    @IBOutlet weak var land_text: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make rounded corners for done button
        done_button.layer.cornerRadius = 10
        done_button.layer.borderWidth = 0
        
        // Date formattor initialization and storing landing date
        vars.formatter.dateStyle = DateFormatter.Style.medium
        vars.formatter.timeStyle = DateFormatter.Style.none
        land_text.text = vars.formatter.string(from: vars.land_date)
        
        // Date picker initialization and color changes
        let datePicker:UIDatePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.setValue(UIColor.red, forKey: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(ViewController2.datePickerValueChanged), for: UIControlEvents.valueChanged)
        land_text.inputView = datePicker
        // Input text field with the datepicker
        
        // Testing pr_citi_flag
        /*if (vars.pr_citi_flag == 0) {
            land_label.text = "Permanent Resident"
        }
        else {
            land_label.text = "Citizen"
        }*/
        // Do any additional setup after loading the view.
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        // Format, store and display the selected date every time datepicker is changed
        vars.land_date = sender.date
        land_text.text = vars.formatter.string(from: vars.land_date)
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
