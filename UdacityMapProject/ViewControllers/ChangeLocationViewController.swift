//
//  ChangeLocationViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 18/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit

class ChangeLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var LocationTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.LocationTextField.delegate =  self
    }
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        if LocationTextField.text != "" {
            LocationTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        }
    }
}
