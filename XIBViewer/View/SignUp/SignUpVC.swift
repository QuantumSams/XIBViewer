//
//  SignUpVC.swift
//  XIBViewer
//
//  Created by Huy on 28/5/24.
//

import UIKit

// Note: Class main body should not contain implementations, special in Lifecycle -> Readable
final class SignUpVC: UIViewController {
    // MARK: Properties
    
    // MARK: Outlets
    // Note: Should use private (access) weak -> minimize retain cycles
    
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var fullNameField: UITextField!
    @IBOutlet private weak var changeToLoginButton: UIButton!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var phoneField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: Actions
    
    @IBAction func loginOptionTapped(_ sender: UIButton) {
        navigateToCustomViewController()
    }
}

// MARK: UITextFieldDelegate

extension SignUpVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private methods

extension SignUpVC {
    private func setupViews() {
        setupButton(signUpButton)
        setupButton(changeToLoginButton)
        
        setupTextField(fullNameField)
        setupTextField(emailField)
        setupTextField(phoneField)
        setupTextField(passwordField)
        setupTextField(confirmPasswordField)
    }
    
    private func setupButton(_ button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    private func setupTextField(_ textField: UITextField) {
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.systemIndigo.cgColor
        textField.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: 64)])
    }
    
    private func navigateToCustomViewController() {
        let vc = SignInVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
