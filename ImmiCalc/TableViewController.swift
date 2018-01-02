//
//  TableViewController.swift
//  ImmiCalc
//
//  Created by Raining on 2017-06-27.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit
import DatePickerCell

class TableViewController: UITableViewController {
    var cells:NSArray = []
    
    @IBOutlet var from_to_table: UITableView!
    
    override func viewDidLoad() {
        // Let this TableView be an observer of add_button_press notification
        NotificationCenter.default.addObserver(self, selector: #selector(TableViewController.AddButtonNotificationHandler), name: vars.AddButtonNotification, object: nil)
        
        // Reload data to avoid cell disappear bug
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.tableView.isScrollEnabled = false
        // Initialize tableView and datePickerCells
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // Localization of the left label of datepickercell
        let fromString = NSLocalizedString("From", comment: "")
        let toString = NSLocalizedString("To", comment: "")
        vars.datePickerCell.dateStyle = DateFormatter.Style.medium
        vars.datePickerCell.timeStyle = DateFormatter.Style.none
        vars.datePickerCell.datePicker.datePickerMode = UIDatePickerMode.date
        vars.datePickerCell.leftLabel.text = fromString
        vars.datePickerCell2.dateStyle = DateFormatter.Style.medium
        vars.datePickerCell2.timeStyle = DateFormatter.Style.none
        vars.datePickerCell2.datePicker.datePickerMode = UIDatePickerMode.date
        vars.datePickerCell2.leftLabel.text = toString
        // Cells is a 2D array containing sections and rows.
        
        vars.datePickerCell.datePicker.addTarget(self, action: #selector(TableViewController.from_datePickerValueChanged), for: UIControlEvents.valueChanged)
        vars.datePickerCell2.datePicker.addTarget(self, action: #selector(TableViewController.to_datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        cells = [[vars.datePickerCell,vars.datePickerCell2]]
    }
    
    // Handle the notification from add_button_press, if any of the cell is expanded, select the cell again and update height
    func AddButtonNotificationHandler() {
        if (vars.datePickerCell.expanded) {
            print("handled")
            vars.datePickerCell.selectedInTableView(tableView)
            vars.expand_height = 0 - vars.datePickerCell.datePicker.frame.size.height
            from_to_table.contentSize.height = from_to_table.contentSize.height + vars.expand_height
            self.preferredContentSize = from_to_table.contentSize
            self.tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
        }
        if (vars.datePickerCell2.expanded) {
            vars.datePickerCell2.selectedInTableView(tableView)
            vars.expand_height = 0 - vars.datePickerCell2.datePicker.frame.size.height
            from_to_table.contentSize.height = from_to_table.contentSize.height + vars.expand_height
            self.preferredContentSize = from_to_table.contentSize
            self.tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if let datePickerCell = cell as? DatePickerCell {
            return datePickerCell.datePickerHeight()
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if let datePickerCell = cell as? DatePickerCell {
            datePickerCell.selectedInTableView(tableView)
            if (datePickerCell.expanded) {
                vars.expand_height = datePickerCell.datePicker.frame.size.height
            }
            else {
                vars.expand_height = 0 - datePickerCell.datePicker.frame.size.height
            }
            
            // Close the other date picker cell
            if (indexPath.row == 1) {
                if (vars.datePickerCell.expanded) {
                    vars.datePickerCell.selectedInTableView(tableView)
                    vars.expand_height = 0
                    self.preferredContentSize = from_to_table.contentSize
                    self.tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
                }
            }
            else {
                if (vars.datePickerCell2.expanded) {
                    vars.datePickerCell2.selectedInTableView(tableView)
                    vars.expand_height = 0
                    self.preferredContentSize = from_to_table.contentSize
                    self.tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
                }
            }
            
            // TODO: WHEN DATEPICKER CHANGES UPDATE FROM_DATE AND TO_DATE
            // AND WHEN ADD BUTTON IS CLICKED THEY CAN GO ON TO SAVE_CONTAINER
            
            // Notify ViewController3 that table size has changed, so it can react and change view/button frames
            from_to_table.contentSize.height = from_to_table.contentSize.height + vars.expand_height
            self.preferredContentSize = from_to_table.contentSize
            
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cells[section] as AnyObject).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = cells[indexPath.section] as! NSArray
        return section[indexPath.row] as! UITableViewCell
    }
    
    func from_datePickerValueChanged(sender:UIDatePicker) {
        // Format, store and display the selected date every time datepicker is changed
        vars.from_date = sender.date
        if (compareDates(fromdate: vars.to_date, todate: vars.from_date) == 0) {
            let cal  = Calendar.current
            let nextday = cal.date(byAdding: .day, value: 1, to: sender.date)
            vars.datePickerCell2.date = nextday!
            vars.to_date = nextday!
        }
    }
    
    func to_datePickerValueChanged(sender:UIDatePicker) {
        // Format, store and display the selected date every time datepicker is changed
        vars.to_date = sender.date
    }
    
    // Act as an "add button press", to retract all extended cells when leaving the view
    override func viewWillDisappear(_ animated: Bool) {
        AddButtonNotificationHandler()
    }
}
