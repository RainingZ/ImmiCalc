//
//  ViewController3.swift
//  ImmiCalc
//
//  Created by Raining on 2017-06-27.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    @IBOutlet weak var from_to_container: UIView!
    // First tableview for input, second for storage and managing dates
    // Using DatePickerCell from Cocoapod library
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        from_to_container.frame = CGRect(x: from_to_container.frame.origin.x, y: from_to_container.frame.origin.y, width: from_to_container.frame.size.width, height: from_to_container.frame.size.height + vars.expand_height)
        // DOES NOT WORK CORRECTLY, NEED RELATIVE POSITION
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
