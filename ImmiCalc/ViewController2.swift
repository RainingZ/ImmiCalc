//
//  ViewController2.swift
//  ImmiCalc
//
//  Created by Raining on 2017-05-20.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var done_button: UIButton!
    @IBOutlet weak var land_label: UILabel!
    @IBOutlet weak var land_text: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign background image
        //assignBackground(VC: self,name: "iPhone-Maple2.jpg")
        
        // Make rounded corners for done button
        done_button.layer.cornerRadius = 10
        done_button.layer.borderWidth = 0
        
        // Date formattor initialization and storing landing date
        vars.formatter.dateStyle = DateFormatter.Style.medium
        vars.formatter.timeStyle = DateFormatter.Style.none
        
        // When the date is today and not for the other application, copy the date over
        if (vars.pr_citi_flag == 0) {
            if (compareDates(fromdate: vars.pr_land_date, todate: Date()) == 1 && compareDates(fromdate: vars.citi_land_date, todate: Date()) != 1 && vars.pr_dates.isEmpty) {
                vars.pr_land_date = vars.citi_land_date
            }
            land_text.text = vars.formatter.string(from: vars.pr_land_date)
        }
        else {
            if (compareDates(fromdate: vars.pr_land_date, todate: Date()) != 1 && compareDates(fromdate: vars.citi_land_date, todate: Date()) == 1) {
                vars.citi_land_date = vars.pr_land_date
            }
            land_text.text = vars.formatter.string(from: vars.citi_land_date)
        }
        error_label.alpha = 0
        
        // Date picker initialization and color changes
        let datePicker:UIDatePicker = UIDatePicker()
        if (vars.pr_citi_flag == 0) {
            datePicker.date = vars.pr_land_date
        }
        else {
            datePicker.date = vars.citi_land_date
        }
        datePicker.backgroundColor = .clear
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(ViewController2.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        land_text.inputView = UIView()
        land_text.inputAccessoryView = datePicker
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        // Format, store and display the selected date every time datepicker is changed
        // Landing date can be changed after inputing in-Canada dates, therefore some restrictions need to be applied for PR application
        if (vars.pr_citi_flag == 0) {
            if (!vars.pr_dates.isEmpty && compareDates(fromdate: sender.date, todate: vars.pr_dates[0]) == 2) {
                self.view.bringSubview(toFront: error_label)
                error_label.text = "Landing date cannot be changed, some dates-in-Canada are before your input date"
                error_label.alpha = 1
                UIView.animate(withDuration: 2, animations: {self.error_label.alpha = 0})
            }
            else {
                vars.pr_land_date = sender.date
                land_text.text = vars.formatter.string(from: vars.pr_land_date)
            }
        }
        else {
            vars.citi_land_date = sender.date
            land_text.text = vars.formatter.string(from: vars.citi_land_date)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
