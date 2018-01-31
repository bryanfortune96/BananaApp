//
//  LoginViewController.swift
//  Banana
//
//  Created by TQM on 10/3/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var appVersionLb: UILabel!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var response: LoginResponse?
    {
        didSet{
            self.hideLoading()
            if (response?.success)!
            {
                self.userInfo = response?.data
            }
            else {
                let alert = UIAlertController(title: "Warning!", message: response?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var userInfo: UserInfoObject?
    {
        didSet{
            UserDefaults.standard.set(mailTextField.text, forKey: "Email")
            UserDefaults.standard.set(passTextField.text, forKey: "Password")
            UserDefaults.standard.set(userInfo?.token, forKey: "Token")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(userInfo?.id, forKey: "UserID")
            UserDefaults.standard.set(userInfo?.phoneNo, forKey: "Phone")
            UserDefaults.standard.set(userInfo?.address, forKey: "Address")
            UserDefaults.standard.set(userInfo?.userName, forKey: "UserName")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissScreen), name: NSNotification.Name("dismissScreen"), object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        // Do any additional setup after loading the view.
        
        checkLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkLogin()
    {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn
        {
            let email = UserDefaults.standard.string(forKey: "Email")
            let pass = UserDefaults.standard.string(forKey: "Password")
            let param = ["email": email,"password": pass]
            ServiceHelpers.login(param: param) { (response) in
                self.response = response
            }
        }
    }
    
    func setupView()
    {
        mailTextField.text = UserDefaults.standard.string(forKey: "Email")
        passTextField.text = UserDefaults.standard.string(forKey: "Password")
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }

    func dismissScreen()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    ////button funcions
    @IBAction func loginPressed(_ sender: Any) {
        self.showLoading()
        let email = mailTextField.text!
        let pass = passTextField.text!
        let param = ["email": email,"password": pass]
        ServiceHelpers.login(param: param) { (response) in
            self.response = response
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let vc = RegisterViewController()
        vc.email = mailTextField.text!
        vc.psw = passTextField.text!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func getPassPressed(_ sender: Any) {
        
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
