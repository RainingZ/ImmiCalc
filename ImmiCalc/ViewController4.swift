//
//  ViewController4.swift
//  ImmiCalc
//
//  Created by Raining on 2017-07-10.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
}

class ViewController4: UIViewController {

    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var application_date_text: UITextField!
    @IBOutlet weak var perm_citi_label: UILabel!
    @IBOutlet weak var more_label: UILabel!
    @IBOutlet weak var more_date_label: UILabel!
    @IBOutlet weak var stayed_label: UILabel!
    @IBOutlet weak var valid_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign background image
        assignBackground(VC: self,name: "iPhone-Maple1.jpg")
        
        application_date_text.text = vars.formatter.string(from: vars.application_date)
        error_label.alpha = 0
        
        // Datepicker for application date
        let datePicker:UIDatePicker = UIDatePicker()
        datePicker.date = vars.application_date
        datePicker.backgroundColor = .clear
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(ViewController4.datePickerValueChanged), for: UIControlEvents.valueChanged)
        application_date_text.inputView = UIView()
        application_date_text.inputAccessoryView = datePicker
        
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
        more_date_label.layer.masksToBounds = true
        more_date_label.layer.cornerRadius = 5
        more_date_label.layer.borderWidth = 0
        stayed_label.layer.masksToBounds = true
        stayed_label.layer.cornerRadius = 5
        stayed_label.layer.borderWidth = 0
        valid_label.layer.masksToBounds = true
        valid_label.layer.cornerRadius = 5
        valid_label.layer.borderWidth = 0

        let cal  = Calendar.current
        var stayed = 0
        var need_now = 0
        
        var land_date = Date()
        if (vars.pr_citi_flag == 0) {
            land_date = vars.pr_land_date
        }
        else {
            land_date = vars.citi_land_date
        }
        // Main Calculation
//========================================================
// You Have Stayed in Canada for:
//========================================================
        
         // If PR application
        if (vars.pr_citi_flag == 0) {
            // Stayed days
            stayed = inCanadaDays(start: vars.pr_dates[0], end: Date())
        }
            // If citi application
        else {
            // Stayed days
            stayed = inCanadaDays(start: vars.citi_dates[0], end: Date())
        }
        
        stayed_label.text = String(stayed) + " Day(s)"
//========================================================
// Starting Now, You Need to Stay in Canada for:
//========================================================
        let fiveyearsago = cal.date(byAdding: .year, value: -5, to: Date())
        var start = Date()
        var stayedNow = 0
        var stayedBeforeLanding = 0
        var daysNeededAfterNow = 0
        var firstDate = Date()
        
        // If PR application
        if (vars.pr_citi_flag == 0) {
            if (compareDates(fromdate: fiveyearsago!, todate: land_date) == 2) {
            // when landing date is more than (before) 5 years ago (S1)
                start = fiveyearsago!
                stayedNow = inCanadaDays(start: start, end: Date())
                daysNeededAfterNow = 730 - stayedNow
                if (daysNeededAfterNow > 0) {
                    need_now = daysNeededforS1(start:start, daysNeeded:daysNeededAfterNow)
                }
                else {
                    need_now = 0
                }
            }
            else {
                // when landing date is exactly or less than (after) 5 years ago (S2)
                start = land_date
                stayedNow = inCanadaDays(start: start, end: Date())
                daysNeededAfterNow = 730 - stayedNow
                if (daysNeededAfterNow > 0) {
                    let daysBeforeFive = 1826 - Date().interval(ofComponent: .day, fromDate: land_date)
                    if (daysBeforeFive < daysNeededAfterNow) {
                        need_now = daysBeforeFive + daysNeededforS1(start:start, daysNeeded: (daysNeededAfterNow - daysBeforeFive))
                    }
                    else {
                        need_now = daysNeededAfterNow
                    }
                }
                else {
                    need_now = 0
                }
            }
        }
        // If citi application
        else {
            if (compareDates(fromdate: fiveyearsago!, todate: land_date) == 2) {
                // when landing date is more than 5 years ago (S1)
                start = fiveyearsago!
                stayedNow = inCanadaDays(start: vars.citi_land_date, end: Date())
                daysNeededAfterNow = 1095 - stayedNow
                if (daysNeededAfterNow > 0) {
                    need_now = daysNeededforS1(start:start, daysNeeded:daysNeededAfterNow)
                }
                else {
                    need_now = 0
                }
            }
            else {
                // when landing date is exactly or less than 5 years ago (S2)
                start = land_date
                stayedNow = inCanadaDays(start: start, end: Date())
                print(fiveyearsago!)
                // Find the first date after fiveyearsago
                for i in 0...(vars.citi_dates.count-1) {
                    if (compareDates(fromdate: fiveyearsago!, todate: vars.citi_dates[i]) == 0) {
                        // When the first date after fiveyearsago is an in-date
                        if (i % 2 == 0) {
                            firstDate = vars.citi_dates[i]
                            break
                        }
                        // When the first date after fiveyearsago is an out-date
                        else {
                            firstDate = fiveyearsago!
                            break
                        }
                    }
                }
                print(firstDate)
                if (compareDates(fromdate: firstDate, todate: vars.citi_land_date) == 0) {
                    stayedBeforeLanding = inCanadaDays(start: firstDate, end: vars.citi_land_date)
                }
                
                // Divide by 2 (currently ceiling, want floor or ceiling?)
                daysNeededAfterNow = 1095 - stayedNow - stayedBeforeLanding/2
                print("daysNeededAfterNow" + String(daysNeededAfterNow))
                if (daysNeededAfterNow > 0) {
                    let daysBeforeFirstDate = firstDate.interval(ofComponent: .day, fromDate: fiveyearsago!)
                    print("daysBeforeFirstDate" + String(daysBeforeFirstDate))
                    if (daysBeforeFirstDate < daysNeededAfterNow) {
                        need_now = daysBeforeFirstDate + daysNeededforS1(start:firstDate, daysNeeded: (daysNeededAfterNow - daysBeforeFirstDate))
                    }
                    else {
                        need_now = daysNeededAfterNow
                    }
                }
                else {
                    need_now = 0
                }
            }
        }
        
        more_label.text = String(need_now) + " Day(s) Till"
        more_date_label.text = vars.formatter.string(from: cal.date(byAdding: .day, value: need_now, to: Date())!)
        applicationDateValidation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func daysNeededforS1(start:Date, daysNeeded:Int) -> Int {
        let cal  = Calendar.current
        var need = daysNeeded
        var halfneed = 0
        var start = start
        var sum = 0
        print(start)
        print(need)
        // Recursively get inCanadaDays for periods of "daysNeeded", we'll need to stay in Canada to make up for periods we stayed in Canada 5 years ago, since as time passes, those will not count anymore
        var count_half_flag = vars.pr_citi_flag
        while (need != 0) {
            sum = sum + need
            // if PR application
            if (count_half_flag == 0) {
                need = inCanadaDays(start: start, end: cal.date(byAdding: .day, value: need - 1, to: start)!)
            }
            // if Citizen application
            else {
                // if Citizen application and calculation reached land date, the calculation method will be changed to be the same as PR application (in this case finish the last calculation first)
                if (compareDates(fromdate: vars.citi_land_date, todate: start) == 0) {
                    need = inCanadaDays(start: start, end: cal.date(byAdding: .day, value: need - 1, to: start)!)
                    count_half_flag = 0
                    print("if")
                }
                else if (compareDates(fromdate: vars.citi_land_date, todate: cal.date(byAdding: .day, value: need - 1, to: start)!) == 0) {
                    halfneed = inCanadaDays(start: start, end: cal.date(byAdding: .day, value: -1, to: vars.citi_land_date)!) / 2
                    need = halfneed + inCanadaDays(start: vars.citi_land_date, end: cal.date(byAdding: .day, value: need - 1, to: start)!)
                    count_half_flag = 0
                    print("elseif")
                }
                else {
                    need = inCanadaDays(start: start, end: cal.date(byAdding: .day, value: need - 1, to: start)!) / 2
                    print("else")
                }
            }
            start = cal.date(byAdding: .day, value: need, to: start)!
            print("need" + String(need))
        }
        
        return sum
    }

    // Calculates in-Canada days between start and end
    func inCanadaDays(start:Date, end:Date) -> Int {
        var stayednow = 0
        var daysbetween = 0
        var from = Date()
        var to = Date()
        var dates = [Date]()
        if (vars.pr_citi_flag == 0) {
            dates = vars.pr_dates
        }
        else {
            dates = vars.citi_dates
        }

        for i in 1...(dates.count/2) {
            from = dates[i*2-2]
            to = dates[i*2-1]
            if ((compareDates(fromdate: from, todate: start) == 0 && compareDates(fromdate: to, todate: start) == 0) || (compareDates(fromdate: from, todate: end) == 2 && compareDates(fromdate: from, todate: end) == 2)) {
                stayednow = stayednow + 0
            }
            else {
                // if (from < start)
                if (compareDates(fromdate: from, todate: start) == 0) {
                    from = start
                }
                // if (from > now)
                if (compareDates(fromdate: from, todate: end) == 2) {
                    from = end
                }
                // if (to < start)
                if (compareDates(fromdate: to, todate: start) == 0) {
                    to = start
                }
                // if (to > now)
                if (compareDates(fromdate: from, todate: end) == 2) {
                    to = end
                }
                daysbetween = to.interval(ofComponent: .day, fromDate: from)
                if (vars.pr_citi_flag == 0) {
                    stayednow = stayednow + daysbetween + 1
                }
                else {
                    stayednow = stayednow + daysbetween
                }
            }
        }
        return stayednow
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        var land_date = Date()
        if (vars.pr_citi_flag == 0) {
            land_date = vars.pr_land_date
        }
        else {
            land_date = vars.citi_land_date
        }
        if (compareDates(fromdate: sender.date, todate: land_date) == 0) {
            self.view.bringSubview(toFront: error_label)
            error_label.text = "Application Date Cannot Be Before\nLanding Date"
            error_label.alpha = 1
            UIView.animate(withDuration: 2, animations: {self.error_label.alpha = 0})
        }
        else {
            vars.application_date = sender.date
            application_date_text.text = vars.formatter.string(from: vars.application_date)
            applicationDateValidation()
        }
    }
    
    func applicationDateValidation() {
//========================================================
// Application Date Validation:
//========================================================
        let cal  = Calendar.current
        let fiveyearsago = cal.date(byAdding: .year, value: -5, to: vars.application_date)
        var start = Date()
        var stayed = 0
        var stayedBeforeLanding = 0
        var firstDate = Date()
        
        // If PR application
        if (vars.pr_citi_flag == 0) {
            if (compareDates(fromdate: fiveyearsago!, todate: vars.pr_land_date) == 2) {
                // when landing date is more than 5 years ago
                start = fiveyearsago!
                stayed = inCanadaDays(start: start, end: vars.application_date)
            }
            else {
                // when landing date is exactly or less than 5 years ago
                start = vars.pr_land_date
                stayed = inCanadaDays(start: start, end: vars.application_date)
            }
            if (stayed < 730) {
                valid_label.text = "Invalid Application Date"
                valid_label.backgroundColor = UIColor.red
            }
            else {
                valid_label.text = "Valid Application Date"
                valid_label.backgroundColor = UIColor.green
            }
        }
            
            // If citi application
        else {
            if (compareDates(fromdate: fiveyearsago!, todate: vars.citi_land_date) == 2) {
                // when landing date is more than 5 years ago (S1)
                start = fiveyearsago!
                stayed = inCanadaDays(start: start, end: vars.application_date)
            }
            else {
                // when landing date is exactly or less than 5 years ago (S2)
                start = vars.citi_land_date
                stayed = inCanadaDays(start: start, end: vars.application_date)
                // Find the first date after fiveyearsago
                for i in 0...(vars.citi_dates.count-1) {
                    if (compareDates(fromdate: fiveyearsago!, todate: vars.citi_dates[i]) == 0) {
                        // When the first date after fiveyearsago is an in-date
                        if (i % 2 == 0) {
                            firstDate = vars.citi_dates[i]
                            break
                        }
                            // When the first date after fiveyearsago is an out-date
                        else {
                            firstDate = fiveyearsago!
                            break
                        }
                    }
                }
                
                if (compareDates(fromdate: firstDate, todate: vars.citi_land_date) == 0) {
                    stayedBeforeLanding = inCanadaDays(start: firstDate, end: vars.citi_land_date)
                }
                
                stayed = stayed + stayedBeforeLanding/2
            }
            if (stayed < 1095) {
                valid_label.text = "Invalid Application Date"
                valid_label.backgroundColor = UIColor.red
            }
            else {
                valid_label.text = "Valid Application Date"
                valid_label.backgroundColor = UIColor.green
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
}
