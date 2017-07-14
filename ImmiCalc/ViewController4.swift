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

    @IBOutlet weak var perm_citi_label: UILabel!
    @IBOutlet weak var more_label: UILabel!
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
        stayed_label.layer.masksToBounds = true
        stayed_label.layer.cornerRadius = 5
        stayed_label.layer.borderWidth = 0
        
        let cal  = Calendar.current
        var stayed = 0
        var need_now = 0
        var daysbetween = 0
        
        var from = Date()
        var to = Date()
        // Main Calculation
//========================================================
// You Have Stayed in Canada for:
//========================================================
        
        for i in 1...(vars.dates.count/2) {
            from = vars.dates[i*2-2]
            to = vars.dates[i*2-1]
            daysbetween = to.interval(ofComponent: .day, fromDate: from)
            print(daysbetween)
            // If PR application
            if (vars.pr_citi_flag == 0) {
                // Stayed days
                stayed = stayed + daysbetween + 1 // add 1 to include both in and out dates, according to the bill
            }
            // If citi application
            else {
                // Stayed days
                stayed = stayed + daysbetween
            }
        }
        
        stayed_label.text = String(stayed) + " Days"
//========================================================
// Starting Now, You Need to Stay in Canada for:
//========================================================
        let fiveyearsago = cal.date(byAdding: .year, value: -5, to: Date())
        var start = Date()
        var stayedNow = 0
        var daysNeededAfterNow = 0
        
        // If PR application
        if (vars.pr_citi_flag == 0) {
            if (compareDates(fromdate: fiveyearsago!, todate: vars.land_date) == 2) {
            // when landing date is more than 5 years ago (S1)
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
                // when landing date is exactly or less than 5 years ago (S2)
                start = vars.land_date
                stayedNow = inCanadaDays(start: start, end: Date())
                daysNeededAfterNow = 730 - stayedNow
                if (daysNeededAfterNow > 0) {
                    let daysBeforeFive = 1826 - Date().interval(ofComponent: .day, fromDate: vars.land_date)
                    print(daysBeforeFive)
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
            //
        }
        
        more_label.text = String(need_now) + " Days"
//========================================================
//
//========================================================
        
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
    
    func daysNeededforS1(start:Date, daysNeeded:Int) -> Int {
        //TODO
        return 0
    }

    // Calculates in-Canada days between start and end
    func inCanadaDays(start:Date, end:Date) -> Int {
        var stayednow = 0
        var daysbetween = 0
        var from = Date()
        var to = Date()
        for i in 1...(vars.dates.count/2) {
            from = vars.dates[i*2-2]
            to = vars.dates[i*2-1]
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
        print(stayednow)
        return stayednow
    }
}
