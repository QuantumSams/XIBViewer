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
        navigateToTabBarController(toTabBarController: SettingTabBarController())
        
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
        button.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: Constant.ButtonConstant.heightAnchor)])
    }
    
    private func setupTextField(_ textField: UITextField) {
        textField.delegate = self // explaination needed
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.borderColor = UIColor.systemIndigo.cgColor
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
    }
    
    private func navigateToCustomViewController(toViewController: UIViewController) {
        navigationController?.pushViewController(toViewController, animated: true)
    }
    
    private func navigateToTabBarController(toTabBarController: UITabBarController){
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.swapRootVC(toTabBarController) //explaination needed
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
