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

    @IBOutlet weak var for_label: UILabel!
    @IBOutlet weak var eligibility_by_label: UILabel!
    @IBOutlet weak var ready_label: UILabel!
    @IBOutlet weak var total_presence_label: UILabel!
    @IBOutlet weak var effective_presence_label: UILabel!
    @IBOutlet weak var extra_days_label: UILabel!
    @IBOutlet weak var earliest_date_label: UILabel!
    @IBOutlet weak var earliest_date_title_label: UILabel!
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var home_button: UIButton!
    @IBOutlet weak var info_button: UIButton!
    @IBOutlet weak var application_date_text: UITextField!
    let resetmsgString = NSLocalizedString("This will clear all saved data, are you sure?", comment: "")
    let okString = NSLocalizedString("OK", comment: "")
    let cancelString = NSLocalizedString("Cancel", comment: "")
    @IBAction func reset_pressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message:resetmsgString, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: okString, style: .destructive, handler: resetHandler)
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel, handler: nil)
        optionMenu.addAction(okAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func home_pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToVC1", sender: self)
    }
    
    func resetHandler(alert: UIAlertAction!) {
        let defaults = UserDefaults.standard
        vars.pr_dates.removeAll()
        vars.citi_dates.removeAll()
        vars.pr_land_date = Date()
        vars.citi_land_date = Date()
        vars.application_date = Date()
        vars.pr_citi_flag = -1
        vars.pr_DoNotNotify = false
        vars.citi_DoNotNotify = false
        vars.termsAccepted = false
        vars.from_date = Date()
        vars.to_date = Date()
        vars.datePickerCell.date = Date()
        vars.datePickerCell2.date = Date()
        defaults.set(vars.pr_citi_flag, forKey: "pr_citi_flag")
        defaults.set(vars.pr_land_date, forKey: "pr_land_date")
        defaults.set(vars.citi_land_date, forKey: "citi_land_date")
        defaults.set(vars.pr_dates, forKey: "pr_dates")
        defaults.set(vars.citi_dates, forKey: "citi_dates")
        defaults.set(vars.application_date, forKey: "application_date")
        defaults.set(vars.termsAccepted, forKey: "termsAccepted")
        defaults.set(vars.pr_DoNotNotify, forKey: "pr_DoNotNotify")
        defaults.set(vars.citi_DoNotNotify, forKey: "citi_DoNotNotify")
        defaults.synchronize()
        print("backgroundset")
        self.performSegue(withIdentifier: "unwindToVC1", sender: self)
    }
    
    @IBAction func application_date_text_edit_begin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.25, animations: {self.home_button.alpha = 0})
        UIView.animate(withDuration: 0.25, animations: {self.info_button.alpha = 0})
    }
    
    @IBAction func application_date_text_edit_end(_ sender: UITextField) {
        UIView.animate(withDuration: 0.25, animations: {self.home_button.alpha = 1})
        UIView.animate(withDuration: 0.25, animations: {self.info_button.alpha = 1})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        // Assign background image
        assignBackground(VC: self,name: "iPhone-Black.jpg")
        
        var land_date = Date()
        
        // If PR application
        if (vars.pr_citi_flag == 0) {
            land_date = vars.pr_land_date
            earliest_date_label.isHidden = true
            earliest_date_title_label.isHidden = true
        }
        // If citi application
        else {
            land_date = vars.citi_land_date
            earliest_date_label.isHidden = false
            earliest_date_title_label.isHidden = false
        }
        
        application_date_text.text = vars.formatter.string(from: vars.application_date)
        error_label.alpha = 0
        
        // Datepicker for application date
        let datePicker:UIDatePicker = UIDatePicker()
        datePicker.date = vars.application_date
        datePicker.backgroundColor = .clear
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(ViewController4.datePickerValueChanged), for: UIControlEvents.valueChanged)
        datePicker.minimumDate = land_date
        //datePicker.maximumDate = cal.date(byAdding: .year, value: 100, to: land_date)
        application_date_text.inputView = UIView()
        application_date_text.inputAccessoryView = datePicker

        calculations()
    }

    func calculations() {
        let cal  = Calendar.current
        var stayed = 0
        var need_now = 0
        var land_date = Date()
        // Main Calculation
        //========================================================
        // You Have Stayed in Canada for:
        //========================================================
        
        // Localization for summary page title
        let forprString = NSLocalizedString("For Permanent Resident Renewal", comment: "")
        let forcitiString = NSLocalizedString("For Citizenship", comment: "")
        // If PR application
        if (vars.pr_citi_flag == 0) {
            // Stayed days
            for_label.text = forprString
            land_date = vars.pr_land_date
            stayed = inCanadaDays(start: vars.pr_dates[0], end: vars.application_date)
        }
        // If citi application
        else {
            // Stayed days
            for_label.text = forcitiString
            land_date = vars.citi_land_date
            stayed = inCanadaDays(start: vars.citi_dates[0], end: vars.application_date)
        }
        
        //========================================================
        // Starting application date, You Need to Stay in Canada for:
        //========================================================
        let fiveyearsago = cal.date(byAdding: .year, value: -5, to: vars.application_date)
        var start = Date()
        var stayedNow = 0
        var stayedBeforeLanding = 0
        var daysNeededAfterNow = 0
        var firstDate = Date()
        var firstDateIndex = 0
        var firstValidDate = Date()
        // If PR application
        if (vars.pr_citi_flag == 0) {
            if (compareDates(fromdate: fiveyearsago!, todate: land_date) == 2) {
                // when landing date is more than (before) 5 years ago (S1)
                start = fiveyearsago!
                stayedNow = inCanadaDays(start: start, end: vars.application_date)
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
                stayedNow = inCanadaDays(start: start, end: vars.application_date)
                daysNeededAfterNow = 730 - stayedNow
                if (daysNeededAfterNow > 0) {
                    let daysBeforeFive = 1826 - vars.application_date.interval(ofComponent: .day, fromDate: land_date)
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
                stayedNow = inCanadaDays(start: start, end: vars.application_date)
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
                stayedNow = inCanadaDays(start: start, end: vars.application_date)
                // Find the first date after fiveyearsago
                for i in 0...(vars.citi_dates.count-1) {
                    if (compareDates(fromdate: fiveyearsago!, todate: vars.citi_dates[i]) == 0) {
                        // When the first date after fiveyearsago is an in-date
                        if (i % 2 == 0) {
                            firstDate = vars.citi_dates[i]
                            firstDateIndex = i + 1
                            break
                        }
                            // When the first date after fiveyearsago is an out-date
                        else {
                            firstDate = fiveyearsago!
                            firstDateIndex = i
                            break
                        }
                    }
                }
                if (compareDates(fromdate: firstDate, todate: vars.citi_land_date) == 0) {
                    stayedBeforeLanding = inCanadaDays(start: firstDate, end: vars.citi_land_date)
                }
                
                // Maximum of 365 days of credit
                if (stayedBeforeLanding > 730) {
                    var sum = 0
                    var offset = 0
                    sum = sum + inCanadaDays(start: firstDate, end: vars.citi_dates[firstDateIndex])
                    if (sum > stayedBeforeLanding - 730) {
                        offset = stayedBeforeLanding - 730 - sum
                        firstValidDate = cal.date(byAdding: .day, value: offset, to: vars.citi_dates[firstDateIndex])!
                    }
                    else {
                        while (sum < stayedBeforeLanding - 730) {
                            sum = sum + inCanadaDays(start: vars.citi_dates[firstDateIndex + 1], end: vars.citi_dates[firstDateIndex + 2])
                            firstDateIndex = firstDateIndex + 2
                        }
                        offset = stayedBeforeLanding - 730 - sum
                        firstValidDate = cal.date(byAdding: .day, value: offset, to: vars.citi_dates[firstDateIndex])!
                    }
                    // If number of days in Canada before landing date & after five years ago is more than 730 days, it will count as 730 days, so the first (inCanada - 730) days will not be counted. Therefore we calculate the first valid day, which is not the first day in this case
                    firstDate = firstValidDate
                    stayedBeforeLanding = 730
                }
                
                // Divide by 2 (currently ceiling, want floor or ceiling?)
                daysNeededAfterNow = 1095 - stayedNow - stayedBeforeLanding/2
                if (daysNeededAfterNow > 0) {
                    let daysBeforeFirstDate = firstDate.interval(ofComponent: .day, fromDate: fiveyearsago!)
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
        applicationDateValidation()
        
        // Localization
        let eligibilityString = NSLocalizedString("Eligibility By ", comment: "")
        eligibility_by_label.text = eligibilityString + vars.formatter.string(from: vars.application_date)
        
        // Localization of yes/no
        let yesString = NSLocalizedString("YES", comment: "")
        let noString = NSLocalizedString("NO", comment: "")
        if (need_now == 0) {
            ready_label.text = yesString
            ready_label.backgroundColor = UIColor.green
        }
        else {
            ready_label.text = noString
            ready_label.backgroundColor = UIColor.red
        }
        
        total_presence_label.text = String(stayed)
        extra_days_label.text = String(need_now)
        earliest_date_label.text = vars.formatter.string(from: cal.date(byAdding: .day, value: need_now, to: vars.application_date)!)
    }

    func daysNeededforS1(start:Date, daysNeeded:Int) -> Int {
        let cal  = Calendar.current
        var need = daysNeeded
        var halfneed = 0
        var start = start
        var sum = 0
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
                }
                else if (compareDates(fromdate: vars.citi_land_date, todate: cal.date(byAdding: .day, value: need - 1, to: start)!) == 0) {
                    halfneed = inCanadaDays(start: start, end: cal.date(byAdding: .day, value: -1, to: vars.citi_land_date)!) / 2
                    need = halfneed + inCanadaDays(start: vars.citi_land_date, end: cal.date(byAdding: .day, value: need - 1, to: start)!)
                    count_half_flag = 0
                }
                else {
                    need = inCanadaDays(start: start, end: cal.date(byAdding: .day, value: need - 1, to: start)!) / 2
                }
            }
            start = cal.date(byAdding: .day, value: need, to: start)!
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
                // if (from > end)
                if (compareDates(fromdate: from, todate: end) == 2) {
                    from = end
                }
                // if (to < start)
                if (compareDates(fromdate: to, todate: start) == 0) {
                    to = start
                }
                // if (to > end)
                if (compareDates(fromdate: to, todate: end) == 2) {
                    to = end
                }
                daysbetween = to.interval(ofComponent: .day, fromDate: from)
                // Citizen counts both in and out dates the same as PR
                stayednow = stayednow + daysbetween + 1
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
            error_label.text = "Application Date Cannot Be Before Landing Date"
            error_label.alpha = 1
            UIView.animate(withDuration: 2, animations: {self.error_label.alpha = 0})
        }
        else {
            vars.application_date = sender.date
            application_date_text.text = vars.formatter.string(from: vars.application_date)
            calculations()
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
                
                // Maximum credit of 365 days for days before landing
                if (stayedBeforeLanding >= 730) {
                    stayedBeforeLanding = 730
                }
                
                stayed = stayed + stayedBeforeLanding/2
            }
        }
        effective_presence_label.text = String(stayed)
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
