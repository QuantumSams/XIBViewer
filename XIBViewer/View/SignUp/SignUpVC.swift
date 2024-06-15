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
    
    @IBAction func registerTapped(_ sender: UIButton) {
        navigateToCustomViewController(toViewController: AccountVC())
        
    }
    @IBAction func loginOptionTapped(_ sender: UIButton) {
        navigateToCustomViewController(toViewController: SignInVC())
    }
}

// MARK: UITextFieldDelegate

extension SignUpVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    private func setupTextField(_ textField: UITextField) {
        textField.delegate = self // explaination needed
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.systemIndigo.cgColor
        textField.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: 64)])
    }
    
    private func navigateToCustomViewController(toViewController: UIViewController) {
        navigationController?.pushViewController(toViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
