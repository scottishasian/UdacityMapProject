//
//  LoginViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 03/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNameTextField.delegate = self
        PasswordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressLoginButton(_ sender: Any) {
        let username = UserNameTextField.text
        let password = PasswordTextField.text
        
        if username != "" && password != "" {
            logUserIn(userName: username!, password: password!)
            print("Can log in")
        } else {
            print("Please type in a username or password")
        }
    }
    
    func logUserIn(userName : String, password : String) {
        
    }
}
