//
//  DisclaimerViewController.swift
//  ImmiCalc
//
//  Created by Raining on 2017-07-31.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {
    @IBOutlet weak var accept_button: UIButton!
    @IBOutlet weak var disclaimer_text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackground(VC: self,name: "iPhone-Black.jpg")
        // Localization of accept button
        let closeString = NSLocalizedString("Close", comment: "")
        let acceptString = NSLocalizedString("Accept", comment: "")
        let disclaimerString = NSLocalizedString("disclaimer", comment: "")
        disclaimer_text.text = disclaimerString
        if (vars.termsAccepted) {
            accept_button.setTitle(closeString, for: .normal)
        }
        else {
            accept_button.setTitle(acceptString, for: .normal)
        }
        accept_button.layer.cornerRadius = 10
        accept_button.layer.borderWidth = 0
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accept_button_pressed(_ sender: UIButton) {
        if (!vars.termsAccepted) {
            print(vars.termsAccepted)
            vars.termsAccepted = true

        }
        //_ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        defaults.set(vars.termsAccepted, forKey: "termsAccepted")
        defaults.synchronize()
    }
    
    // Make sure text view starts at top
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        disclaimer_text.setContentOffset(CGPoint.zero, animated: false)
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
