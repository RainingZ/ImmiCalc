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
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // The DatePickerCell.
        let datePickerCell = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        let datePickerCell2 = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        datePickerCell.dateStyle = DateFormatter.Style.medium
        datePickerCell.timeStyle = DateFormatter.Style.none
        datePickerCell.datePicker.datePickerMode = UIDatePickerMode.date
        datePickerCell.leftLabel.text = "From"
        datePickerCell2.dateStyle = DateFormatter.Style.medium
        datePickerCell2.timeStyle = DateFormatter.Style.none
        datePickerCell2.datePicker.datePickerMode = UIDatePickerMode.date
        datePickerCell2.leftLabel.text = "To"
        // Cells is a 2D array containing sections and rows.
        cells = [[datePickerCell,datePickerCell2]]
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
            from_to_table.frame = CGRect(x: from_to_table.frame.origin.x, y: from_to_table.frame.origin.y, width: from_to_table.frame.size.width, height: from_to_table.frame.size.height + datePickerCell.datePicker.frame.size.height)
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            // TODO: change table size here
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
    
    
}
