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
        
        // Assign background image
        assignBackground(VC: self,name: "iPhone-Maple1.jpg")
        
        // Make rounded corners for done button
        done_button.layer.cornerRadius = 10
        done_button.layer.borderWidth = 0
        
        // Date formattor initialization and storing landing date
        vars.formatter.dateStyle = DateFormatter.Style.medium
        vars.formatter.timeStyle = DateFormatter.Style.none
        land_text.text = vars.formatter.string(from: vars.land_date)
        
        // Date picker initialization and color changes
        let datePicker:UIDatePicker = UIDatePicker()
        datePicker.backgroundColor = .clear
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(ViewController2.datePickerValueChanged), for: UIControlEvents.valueChanged)
        land_text.inputAccessoryView = datePicker
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        // Format, store and display the selected date every time datepicker is changed
        // Landing date can be changed after inputing away-from-Canada dates, therefore some restrictions need to be applied
        if (!vars.dates.isEmpty && sender.date >= vars.dates[0]) {
            print("Landing date cannot be changed, some dates-away-from-Canada are less than your value")
        }
        else {
            vars.land_date = sender.date
            land_text.text = vars.formatter.string(from: vars.land_date)
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
