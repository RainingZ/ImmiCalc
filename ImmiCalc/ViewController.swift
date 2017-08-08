//
//  ViewController.swift
//  ImmiCalc
//
//  Created by Raining on 2017-05-19.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit
import Foundation
import DatePickerCell

// Global variables
struct vars {
    static let formatter = DateFormatter()
    static var pr_citi_flag:Int = -1
    static var pr_land_date = Date()
    static var citi_land_date = Date()
    static var expand_height:CGFloat = 0
    static var pr_dates = [Date]()
    static var citi_dates = [Date]()
    static var from_date = Date()
    static var to_date = Date()
    static var application_date = Date()
    //DatePickerCells
    static let datePickerCell = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    static let datePickerCell2 = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    //Notification
    static let AddButtonNotification = Notification.Name("AddButtonNotification")
    
    static var DoNotNotify:Bool = false
    static var termsAccepted:Bool = false
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView {
    func makeBlurImage(targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        blurEffectView.alpha = 0.9
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
}

func assignBackground(VC:UIViewController, name:String) {
    let background = UIImage(named: name)
    var imageView: UIImageView!
    imageView = UIImageView(frame: VC.view.bounds)
    imageView.contentMode = UIViewContentMode.scaleAspectFill
    imageView.image = background
    imageView.center = VC.view.center
    VC.view.addSubview(imageView)
    imageView.makeBlurImage(targetImageView: imageView)
    VC.view.sendSubview(toBack: imageView)
}

class ViewController: UIViewController {
    @IBOutlet weak var pr_button: UIButton!
    @IBOutlet weak var citi_button: UIButton!
    
    // Prepare to unwind on VC4 reset button
    @IBAction func prepareForUnwindVC1(segue: UIStoryboardSegue) {
    }
    
    // Set pr_citi_flag
    @IBAction func PR_button_pressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showView2", sender: self)
        if (vars.pr_citi_flag == 1) {
            vars.DoNotNotify = false
        }
        vars.pr_citi_flag = 0
    }
    
    @IBAction func Citi_button_pressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showView2", sender: self)
        if (vars.pr_citi_flag == 0) {
            vars.DoNotNotify = false
        }
        vars.pr_citi_flag = 1
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        vars.pr_citi_flag = defaults.integer(forKey: "pr_citi_flag")
        vars.pr_land_date = defaults.object(forKey: "pr_land_date") as! Date
        vars.citi_land_date = defaults.object(forKey: "citi_land_date") as! Date
        vars.pr_dates = defaults.array(forKey: "pr_dates") as! [Date]
        vars.citi_dates = defaults.array(forKey: "citi_dates") as! [Date]
        vars.application_date = defaults.object(forKey: "application_date") as! Date
        vars.termsAccepted = defaults.bool(forKey: "termsAccepted")
        vars.DoNotNotify = defaults.bool(forKey: "DoNotNotify")
        print("launchget")
        // Assign background image
        //assignBackground(VC: self,name: "MapleLeafOnWater.jpg")
        
        // Make rounded corners for buttons
        pr_button.layer.cornerRadius = 10
        pr_button.layer.borderWidth = 0
        citi_button.layer.cornerRadius = 10
        citi_button.layer.borderWidth = 0
        
        if (!vars.termsAccepted) {
            performSegue(withIdentifier: "showDisclaimer", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
}

