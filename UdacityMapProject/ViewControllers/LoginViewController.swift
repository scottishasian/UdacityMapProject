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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func pressLoginButton(_ sender: Any) {
        let username = UserNameTextField.text
        let password = PasswordTextField.text
        
        if username != "" && password != "" {
            LoadingIndicator.isHidden = false
            self.LoadingIndicator.startAnimating()
            logUserIn(userName: username!, password: password!)
            dismissKeyboard()
            print("Can log in")
        } else {
            print("Please type in a username or password")
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func logUserIn(userName : String, password : String) {
        DataClient.sharedInstance().authenticateUser(username: userName, password: password) {(success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.UserNameTextField.text = ""
                    self.PasswordTextField.text = ""
                }
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AppEntranceController") as! UITabBarController
                self.present(controller, animated: true, completion: nil)
            } else {
                performUIUpdatesOnMain {
                    self.showInfo(withTitle: "Login Error", withMessage: error ?? "Error while performing login.")
                    self.LoadingIndicator.isHidden = true
                    print(error ?? Constants.ErrorMessages.loginError)
                }
            }
            performUIUpdatesOnMain {
                self.LoadingIndicator.stopAnimating()
            }
        }
    }
}
