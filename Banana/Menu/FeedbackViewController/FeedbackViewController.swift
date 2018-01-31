//
//  FeedbackViewController.swift
//  Banana
//
//  Created by TQM on 9/30/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController,MFMailComposeViewControllerDelegate{

    @IBOutlet weak var sendButt: UIButton!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.placeholder = "Your Feedback"
        textField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView()
    {
        //add rounded corner and shadow for textfield
        textField.borderStyle = .roundedRect
        
        //make round shape and add shadow for button
        sendButt.layer.cornerRadius = 55.0/2
        
        //dismiss keyboard while tapping anywhere
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self  // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["tqminh3011@gmail.com"])
        mailComposerVC.setSubject("Feedback Banana Traffic App")
        mailComposerVC.setMessageBody(textField.text!, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent.rawValue:
            self.dismiss(animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    
    ////button actions
    @IBAction func sendPressed(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
