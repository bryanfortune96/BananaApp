//
//  RegisterViewController.swift
//  Banana
//
//  Created by TQM on 10/7/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pswTxtField: UITextField!
    @IBOutlet weak var usrNameTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var confirmPswTxtField: UITextField!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    @IBOutlet weak var constraint3: NSLayoutConstraint!
    @IBOutlet weak var constraint4: NSLayoutConstraint!
    @IBOutlet weak var constraint5: NSLayoutConstraint!
    @IBOutlet weak var constraint6: NSLayoutConstraint!
    @IBOutlet weak var constraint7: NSLayoutConstraint!
    @IBOutlet weak var constraint8: NSLayoutConstraint!
    @IBOutlet weak var constraint9: NSLayoutConstraint!
    @IBOutlet weak var constraint10: NSLayoutConstraint!
    @IBOutlet weak var constraint11: NSLayoutConstraint!
    
    var response: RegisterResponse?
    {
        didSet{
            if (response?.success)!
            {
                self.userInfo = response?.data
            }
            else{
                let alert = UIAlertController(title: "Warning!", message: response?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    var userInfo: RegisterObject?
    {
        didSet{
            UserDefaults.standard.set(emailTxtField.text, forKey: "Email")
            UserDefaults.standard.set(pswTxtField.text, forKey: "Password")
            self.dismiss(animated: true, completion: nil)
          
        }
    }
    var email = ""
    var psw = ""
    var nickname = ""
    var address = ""
    var phone = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupView()
    {
        emailTxtField.text = email
        pswTxtField.text = psw
        let width = UIScreen.main.bounds.width
        if width == 375
        {
            changeConstraint(size: 10.0)
        }
        else if width > 375{
            changeConstraint(size: 15.0)
        }
    }
    
    func changeConstraint(size: CGFloat)
    {
        constraint.constant = size
        constraint2.constant = size
        constraint3.constant = size
        constraint4.constant = size
        constraint5.constant = size
        constraint6.constant = size
        constraint7.constant = size
        constraint8.constant = size
        constraint9.constant = size
        constraint10.constant = size
        constraint11.constant = size
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        let param = ["email": emailTxtField.text, "password": pswTxtField.text, "nickname": usrNameTxtField.text, "phone": phoneTxtField.text, "address": addressTxtField.text,"confirmPassword": confirmPswTxtField.text]
        ServiceHelpers.register(param: param){ (response) in
            self.response = response
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
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
