//
//  SignUpViewController.swift
//  XIBViewer
//
//  Created by Huy on 28/5/24.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var fullNameField: UITextField!
    @IBOutlet var changeToLoginButton: UIButton!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 20
        changeToLoginButton.clipsToBounds = true
        changeToLoginButton.layer.cornerRadius = 20
        
        
        fullNameField.layer.masksToBounds = true
        fullNameField.borderStyle = .roundedRect
        fullNameField.layer.borderWidth = 1.5
        fullNameField.layer.borderColor = UIColor.systemIndigo.cgColor
        fullNameField.layer.cornerRadius = 20
        
        emailField.layer.masksToBounds = true
        emailField.borderStyle = .roundedRect
        emailField.layer.borderWidth = 1.5
        emailField.layer.borderColor = UIColor.systemIndigo.cgColor
        emailField.layer.cornerRadius = 20
        
        phoneField.layer.masksToBounds = true
        phoneField.borderStyle = .roundedRect
        phoneField.layer.borderWidth = 1.5
        phoneField.layer.borderColor = UIColor.systemIndigo.cgColor
        phoneField.layer.cornerRadius = 20
        
        passwordField.layer.masksToBounds = true
        passwordField.borderStyle = .roundedRect
        passwordField.layer.borderWidth = 1.5
        passwordField.layer.borderColor = UIColor.systemIndigo.cgColor
        passwordField.layer.cornerRadius = 20
        
        confirmPasswordField.layer.masksToBounds = true
        confirmPasswordField.borderStyle = .roundedRect
        confirmPasswordField.layer.borderWidth = 1.5
        confirmPasswordField.layer.borderColor = UIColor.systemIndigo.cgColor
        confirmPasswordField.layer.cornerRadius = 20
    }

    @IBAction func loginOptionTapped(_ sender: UIButton) {
        let vc = CustomViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}

extension SignUpViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
