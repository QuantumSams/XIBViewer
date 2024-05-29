//
//  CustomViewController.swift
//  XIBViewer
//
//  Created by Huy on 28/5/24.
//

import UIKit

class CustomViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        usernameField.layer.cornerRadius = 20
        usernameField.layer.borderColor = UIColor.systemBlue.cgColor
        usernameField.layer.borderWidth = 1
        usernameField.layer.masksToBounds = true
        usernameField.borderStyle = .roundedRect
        
        passwordField.layer.cornerRadius = 20
        passwordField.layer.borderColor = UIColor.systemBlue.cgColor
        passwordField.layer.borderWidth = 1
        passwordField.layer.masksToBounds = true
        passwordField.borderStyle = .roundedRect
        
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
        
        super.viewDidLoad()
    }
   

    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
}
