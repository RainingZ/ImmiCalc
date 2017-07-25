//
//  ViewController3.swift
//  ImmiCalc
//
//  Created by Raining on 2017-06-27.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit
import DatePickerCell

func compareDates(fromdate:Date, todate:Date) -> Int {
    // 0 is fromdate < todate
    // 1 is fromdate = todate
    // 2 is fromdate > todate
    let order = Calendar.current.compare(fromdate, to: todate, toGranularity: .day)
    switch order {
    case .orderedAscending:
        return 0
    case .orderedDescending:
        return 2
    case .orderedSame:
        return 1
    }
}

class ViewController3: UIViewController {

    @IBOutlet weak var add_button: UIButton!
    @IBOutlet weak var from_to_container: UIView!
    @IBOutlet weak var save_container: UIView!
    
    // First tableview for input, second for storage and managing dates
    // Using DatePickerCell from Cocoapod library
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign background image
        assignBackground(VC: self,name: "iPhone-Maple3.jpg")
        
        add_button.layer.cornerRadius = 5
        add_button.layer.borderWidth = 0
        
        // Arranging layouts
        from_to_container.frame = CGRect(x: self.view.frame.midX - (self.view.frame.width - 40)/2, y: 80, width: self.view.frame.width - 40, height: 88)
        
        add_button.frame = CGRect(x: self.view.frame.midX - (self.view.frame.width - 40)/2, y: 80 + 88 + 8, width: self.view.frame.width - 40, height: 30)
        
        save_container.frame = CGRect(x: self.view.frame.midX - (self.view.frame.width - 40)/2, y: 80 + 88 + 8 + 30 + 8, width: self.view.frame.width - 40, height: self.view.frame.height - 40 - 88 - 8 - 30 - 8 - 60)
        if (!vars.DoNotNotify) {
            var alert = UIAlertController()
            if (vars.pr_citi_flag == 0) {
                alert = UIAlertController(title: "ImmiCalc", message: "Please input all periods of time you spent in Canada after landing date", preferredStyle: UIAlertControllerStyle.alert)
            }
            else {
                alert = UIAlertController(title: "ImmiCalc", message: "Please input all periods of time you spent in Canada, before and after landing date", preferredStyle: UIAlertControllerStyle.alert)
            }

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Don't Show This Again", style: UIAlertActionStyle.default, handler: donotnotify))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        // When one application has dates and the other does not, copy the necessary dates over
        if (vars.pr_citi_flag == 0 && vars.pr_dates.isEmpty && !vars.citi_dates.isEmpty) {
            var temp_dates = [Date]()
            temp_dates = vars.citi_dates
            for i in 0...(temp_dates.count - 1) {
                if (compareDates(fromdate: temp_dates[0], todate: vars.pr_land_date) == 0 || (compareDates(fromdate: temp_dates[0], todate: vars.pr_land_date) == 1 && i % 2 == 1)) {
                    temp_dates.remove(at: 0)
                }
                else if (compareDates(fromdate: temp_dates[0], todate: vars.pr_land_date) == 2 && i % 2 == 1) {
                    temp_dates += [vars.pr_land_date]
                    temp_dates.sort(by: {$0.compare($1) == .orderedAscending})
                    break
                }
                else {
                    break
                }
            }
            vars.pr_dates = temp_dates
        }
        
        if (vars.pr_citi_flag == 1 && vars.citi_dates.isEmpty && !vars.pr_dates.isEmpty) {
            vars.citi_dates = vars.pr_dates
        }
    }
    
    func donotnotify(alert: UIAlertAction!) {
        vars.DoNotNotify = true
        return
    }
    
    @IBAction func add_button_pressed(_ sender: UIButton) {
        // All added dates should be greater than landing date for PR applications
        if (vars.pr_citi_flag == 0 && (compareDates(fromdate: vars.from_date, todate: vars.pr_land_date) == 0 || compareDates(fromdate: vars.to_date, todate: vars.pr_land_date) == 0)) {
            // Pop up
            let alert = UIAlertController(title: "ImmiCalc", message: "All added dates should be greater than landing date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("All added dates should be greater than landing date")
        }
        // All added dates should be before today
        // if (vars.from_date > Date() || vars.to_date > Date())
        /*else if (compareDates(fromdate: vars.from_date, todate: Date()) == 2 || compareDates(fromdate: vars.to_date, todate: Date()) == 2) {
            print("All added dates should be before today")
        }*/
        // From dates need to be smaller or equal to To dates
        // else if (vars.to_date < vars.from_date) {
        else if (compareDates(fromdate: vars.to_date, todate: vars.from_date) == 0) {
            let alert = UIAlertController(title: "ImmiCalc", message: "From dates need to be smaller or equal to To dates", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("From dates need to be smaller or equal to To dates")
        }
        // Both dates need to be outside of an "in-Canada" period
        else if (invalidDates(fromdate: vars.from_date, todate: vars.to_date)) {
            let alert = UIAlertController(title: "ImmiCalc", message: "Both dates need to be outside of an 'in-Canada' period", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("Both dates need to be outside of an 'in-Canada' period")
        }
        // Add dates to array, sort the array, send notification to close cells and reload data on save table
        else {
            if (vars.pr_citi_flag == 0) {
                vars.pr_dates += [vars.from_date, vars.to_date]
                vars.pr_dates.sort(by: {$0.compare($1) == .orderedAscending})
            }
            else {
                vars.citi_dates += [vars.from_date, vars.to_date]
                vars.citi_dates.sort(by: {$0.compare($1) == .orderedAscending})
            }
        }
        
        // Notify TableView to close expanded DatePickerCells, and TableView2 to reload table
        NotificationCenter.default.post(name: vars.AddButtonNotification, object: nil)
        
    }
    
    @IBAction func done_pressed(_ sender: UIButton) {
        var count = 0
        if (vars.pr_citi_flag == 0) {
            count = vars.pr_dates.count
        }
        else {
            count = vars.citi_dates.count
        }
        if (count == 0) {
            let alert = UIAlertController(title: "ImmiCalc", message: "Before proceeding to the result, please input all periods of time you spent in Canada", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "showView4", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        UIView.animate(withDuration: 0.25, animations: {
        self.from_to_container.frame = CGRect(x: self.from_to_container.frame.origin.x, y: self.from_to_container.frame.origin.y, width: self.from_to_container.frame.size.width, height: self.from_to_container.frame.size.height + vars.expand_height)
        
        self.add_button.frame = CGRect(x: self.add_button.frame.origin.x, y: self.add_button.frame.origin.y + vars.expand_height, width: self.add_button.frame.size.width, height: self.add_button.frame.size.height)
        
        self.save_container.frame = CGRect(x: self.save_container.frame.origin.x, y: self.save_container.frame.origin.y + vars.expand_height, width: self.save_container.frame.size.width, height: self.save_container.frame.size.height - vars.expand_height)
        })
        
        // Hide save_container when both from and to cells are expanded
        /*if (vars.datePickerCell.expanded && vars.datePickerCell2.expanded) {
            save_container.isHidden = true
        }
        else {
            save_container.isHidden = false
        }*/
    }

    func invalidDates(fromdate:Date, todate:Date) -> Bool {
        var dates = [Date]()
        if (vars.pr_citi_flag == 0) {
            dates = vars.pr_dates
        }
        else {
            dates = vars.citi_dates
        }

        if (dates.count > 0) {
            for i in 0...dates.count - 1 {
                // fromdate or todate cannot be the same as previous from or to dates
                // if (fromdate == vars.dates[i] || todate == vars.dates[i]) {
                if (compareDates(fromdate: fromdate, todate: dates[i]) == 1 || compareDates(fromdate: todate, todate: dates[i]) == 1) {
                    print("fromdate or todate cannot be the same as previous from or to dates")
                    return true
                }
                // fromdate and todate cannot wrap around a previous from or to dates
                // else if (fromdate < vars.dates[i] && todate > vars.dates[i]) {
                else if (compareDates(fromdate: fromdate, todate: dates[i]) == 0 && compareDates(fromdate: todate, todate: dates[i]) == 2) {
                    print("fromdate and todate cannot wrap around a previous from or to dates")
                    return true
                }
            }
        }
        return false
    }
}
