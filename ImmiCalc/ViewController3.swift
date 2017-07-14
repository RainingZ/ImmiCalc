//
//  ViewController3.swift
//  ImmiCalc
//
//  Created by Raining on 2017-06-27.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit
import DatePickerCell

class ViewController3: UIViewController {

    @IBOutlet weak var done_button: UIBarButtonItem!
    @IBOutlet weak var add_button: UIButton!
    @IBOutlet weak var from_to_container: UIView!
    @IBOutlet weak var save_container: UIView!
    
    // First tableview for input, second for storage and managing dates
    // Using DatePickerCell from Cocoapod library
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign background image
        assignBackground(VC: self,name: "MapleLeafOnWater.jpg")
        
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
    }
    
    func donotnotify(alert: UIAlertAction!) {
        vars.DoNotNotify = true
        return
    }
    
    @IBAction func add_button_pressed(_ sender: UIButton) {
        // All added dates should be greater than landing date for PR applications
        if (vars.pr_citi_flag == 0 && (compareDates(fromdate: vars.from_date, todate: vars.land_date) == 0 || compareDates(fromdate: vars.to_date, todate: vars.land_date) == 0)) {
                // Pop up
            print("All added dates should be greater than landing date")
        }
        // All added dates should be before today
        // if (vars.from_date > Date() || vars.to_date > Date())
        else if (compareDates(fromdate: vars.from_date, todate: Date()) == 2 || compareDates(fromdate: vars.to_date, todate: Date()) == 2) {
            print("All added dates should be before today")
        }
        // From dates need to be smaller or equal to To dates
        // else if (vars.to_date < vars.from_date) {
        else if (compareDates(fromdate: vars.to_date, todate: vars.from_date) == 0) {
            print("From dates need to be smaller or equal to To dates")
        }
        // Both dates need to be outside of an "away-from-Canada" period
        else if (invalidDates(fromdate: vars.from_date, todate: vars.to_date)) {
            print("Both dates need to be outside of an 'away-from-Canada' period")
        }
        // Add dates to array, sort the array, send notification to close cells and reload data on save table
        else {
            vars.dates += [vars.from_date, vars.to_date]
            vars.dates.sort(by: {$0.compare($1) == .orderedAscending})
            print("Date array count: " + String(vars.dates.count))
        }
        
        // Notify TableView to close expanded DatePickerCells, and TableView2 to reload table
        NotificationCenter.default.post(name: vars.AddButtonNotification, object: nil)
        
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
        if (vars.dates.count > 0) {
            for i in 0...vars.dates.count - 1 {
                // fromdate or todate cannot be the same as previous from or to dates
                // if (fromdate == vars.dates[i] || todate == vars.dates[i]) {
                if (compareDates(fromdate: fromdate, todate: vars.dates[i]) == 1 || compareDates(fromdate: todate, todate: vars.dates[i]) == 1) {
                    print("fromdate or todate cannot be the same as previous from or to dates")
                    return true
                }
                // fromdate and todate cannot wrap around a previous from or to dates
                // else if (fromdate < vars.dates[i] && todate > vars.dates[i]) {
                else if (compareDates(fromdate: fromdate, todate: vars.dates[i]) == 0 && compareDates(fromdate: todate, todate: vars.dates[i]) == 2) {
                    print("fromdate and todate cannot wrap around a previous from or to dates")
                    return true
                }
            }
        }
        return false
    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
