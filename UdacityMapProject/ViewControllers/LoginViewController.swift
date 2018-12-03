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
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNameTextField.delegate = self
        PasswordTextField.delegate = self
        LoadingIndicator.isHidden = true

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
            LoadingIndicator.isHidden = false
            self.LoadingIndicator.startAnimating()
            logUserIn(userName: username!, password: password!)
            print("Can log in")
        } else {
            print("Please type in a username or password")
        }
    }
    
    private func logUserIn(userName : String, password : String) {
        DataClient.sharedInstance().authenticateUser(username: userName, password: password) {(success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.UserNameTextField.text = ""
                    self.PasswordTextField.text = ""
                }
                self.performSegue(withIdentifier: "logIntoMap", sender: nil)
            } else {
                performUIUpdatesOnMain {
                    let loginAlert = UIAlertController(title: "Login Error", message: Constants.ErrorMessages.loginError, preferredStyle: UIAlertControllerStyle.alert)
                    loginAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(loginAlert, animated: true, completion: nil)
                    print(error ?? Constants.ErrorMessages.loginError)
                }
            }
            performUIUpdatesOnMain {
                self.LoadingIndicator.stopAnimating()
            }
        }
    }
}
