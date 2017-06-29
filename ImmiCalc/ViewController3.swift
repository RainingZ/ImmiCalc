//
//  ViewController3.swift
//  ImmiCalc
//
//  Created by Raining on 2017-06-27.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    @IBOutlet weak var add_button: UIButton!
    @IBOutlet weak var from_to_container: UIView!
    @IBOutlet weak var save_container: UIView!
    
    // First tableview for input, second for storage and managing dates
    // Using DatePickerCell from Cocoapod library
    override func viewDidLoad() {
        super.viewDidLoad()
        print(from_to_container.frame.origin)
        print(self.view.frame.midX)
        print(self.view.frame.midY)
        print(self.view.frame.width)
        from_to_container.frame = CGRect(x: self.view.frame.midX - (self.view.frame.width - 40)/2, y: 80, width: self.view.frame.width - 40, height: 88)
        
        add_button.frame = CGRect(x: self.view.frame.midX - (self.view.frame.width - 40)/2, y: 80 + 88 + 8, width: self.view.frame.width - 40, height: 30)
        
        save_container.frame = CGRect(x: self.view.frame.midX - (self.view.frame.width - 40)/2, y: 80 + 88 + 8 + 30 + 8, width: self.view.frame.width - 40, height: self.view.frame.height - 40 - 88 - 8 - 30 - 8 - 60)
    }
    
    @IBAction func add_button_pressed(_ sender: UIButton) {
        //var date:Date =
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        from_to_container.frame = CGRect(x: from_to_container.frame.origin.x, y: from_to_container.frame.origin.y, width: from_to_container.frame.size.width, height: from_to_container.frame.size.height + vars.expand_height)
        
        add_button.frame = CGRect(x: add_button.frame.origin.x, y: add_button.frame.origin.y + vars.expand_height, width: add_button.frame.size.width, height: add_button.frame.size.height)
        
        save_container.frame = CGRect(x: save_container.frame.origin.x, y: save_container.frame.origin.y + vars.expand_height, width: save_container.frame.size.width, height: save_container.frame.size.height - vars.expand_height)
        
        // Hide save_container when both from and to cells are expanded
        if (vars.from_expanded && vars.to_expanded) {
            save_container.isHidden = true
        }
        else {
            save_container.isHidden = false
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
