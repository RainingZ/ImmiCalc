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
    static var land_date = Date()
    static var expand_height:CGFloat = 0
    static var dates = [Date]()
    static var from_date = Date()
    static var to_date = Date()
    //DatePickerCells
    static let datePickerCell = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    static let datePickerCell2 = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    //Notification
    static let AddButtonNotification = Notification.Name("AddButtonNotification")
    
    static var DoNotNotify:Bool = false
}

extension UIImageView
{
    func makeBlurImage(targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
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
    
    // Set pr_citi_flag
    @IBAction func PR_button_pressed(_ sender: UIButton) {
        if (vars.pr_citi_flag == 1) {
            let alert = UIAlertController(title: "WARNING", message: "Changing the application type will clear your previous data, are you sure?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: cleardatashowView2))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "showView2", sender: self)
            vars.pr_citi_flag = 0
        }
        vars.DoNotNotify = false
    }
    @IBAction func Citi_button_pressed(_ sender: UIButton) {
        if (vars.pr_citi_flag == 0) {
            let alert = UIAlertController(title: "WARNING", message: "Changing the application type will clear your previous data, are you sure?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: cleardatashowView2))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "showView2", sender: self)
            vars.pr_citi_flag = 1
        }
        vars.DoNotNotify = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change Navigation bar items to white
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Assign background image
        assignBackground(VC: self,name: "MapleLeafOnWater.jpg")
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Make rounded corners for buttons
        pr_button.layer.cornerRadius = 10
        pr_button.layer.borderWidth = 0
        citi_button.layer.cornerRadius = 10
        citi_button.layer.borderWidth = 0
    }

    // Hide the navigation bar on the first page
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cleardatashowView2(alert: UIAlertAction!) {
        if (vars.pr_citi_flag == 1) {
            vars.pr_citi_flag = 0
        }
        else {
            vars.pr_citi_flag = 1
        }
        vars.dates.removeAll()
        performSegue(withIdentifier: "showView2", sender: self)
        return
    }
}

