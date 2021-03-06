//
//  TableViewController2.swift
//  ImmiCalc
//
//  Created by Raining on 2017-07-07.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class TableViewController2: UITableViewController {

    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(TableViewController2.AddButtonNotificationHandler), name: vars.AddButtonNotification, object: nil)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (vars.pr_citi_flag == 0) {
            return (vars.pr_dates.count / 2)
        }
        else {
            return (vars.citi_dates.count / 2)
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "DateTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DateTableViewCell else {
            fatalError("The dequeued cell is not an instance of DateTableViewCell.")
        }

        // Configure the cell...
        var dates = [Date]()
        if (vars.pr_citi_flag == 0) {
            dates = vars.pr_dates
        }
        else {
            dates = vars.citi_dates
        }
        let from_date = dates[indexPath.row * 2]
        let to_date = dates[indexPath.row * 2 + 1]
        cell.from_date_label.text = vars.formatter.string(from: from_date)
        cell.to_date_label.text = vars.formatter.string(from: to_date)
        return cell
    }

    func AddButtonNotificationHandler() {
        tableView.reloadData()
    }
    
    // Swipe left to remove a cell of data
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if (vars.pr_citi_flag == 0) {
                vars.pr_dates.remove(at: indexPath.row * 2)
                vars.pr_dates.remove(at: indexPath.row * 2)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else {
                vars.citi_dates.remove(at: indexPath.row * 2)
                vars.citi_dates.remove(at: indexPath.row * 2)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
