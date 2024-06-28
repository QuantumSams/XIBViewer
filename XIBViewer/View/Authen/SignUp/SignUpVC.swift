import UIKit


final class SignUpVC: UIViewController {
    
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var fullNameField: UITextField!
    @IBOutlet private weak var changeToLoginButton: UIButton!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var roleSelection: UIButton!
    @IBOutlet private weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        signUpButton.configuration?.showsActivityIndicator = true

        
        let signUpData = SignupResponse(name: fullNameField.text ?? "",
                                        email: emailField.text ?? "", 
                                        role: <#Int#>,
                                        password: passwordField.text ?? "")
        
        
        
        
        
        navigateToTabBarController()
    }
    @IBAction func loginOptionTapped(_ sender: UIButton) {
        navigateToCustomViewController(toViewController: SignInVC())
    }
}


extension SignUpVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension SignUpVC {
    private func setupViews() {
        setupButton(signUpButton)
        setupButton(changeToLoginButton)
        setupPopUpButton(for: roleSelection)
        setupTextField(fullNameField)
        setupTextField(emailField)
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
    
    private func navigateToTabBarController(){
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.checkAuthen() //explaination needed
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
extension SignUpVC{
    
    private func setupPopUpButton(for button: UIButton){
        button.setupButton(tintColor: Constant.PopUpButtonConstant.tintColor,
                           borderColor: Constant.PopUpButtonConstant.borderColor,
                           cornerRadius: Constant.PopUpButtonConstant.cornerRadius,
                           borderWidth: Constant.PopUpButtonConstant.borderWidth,
                           maskToBound: false)
        
        setupLogicPopupButton(popUpButton: button)
    }
    
    private func setupLogicPopupButton(popUpButton: UIButton){
        
        
        DispatchQueue.main.async {
            popUpButton.menu = UIMenu(children: self.convertRoleModel(from: RoleSingleton.accessSingleton.getRole()))
            popUpButton.showsMenuAsPrimaryAction = true
            popUpButton.changesSelectionAsPrimaryAction = true
            (popUpButton.menu?.children[0] as? UIAction)?.state = .on
        }
    
        
    }
    
    private func convertRoleModel(from: [RoleModel]) -> [UIAction]{
        let changeNameClosure = {(incomingAction: UIAction) in
            //TODO: update to DB about role changes
        }
        var out: [UIAction] = []
        
        from.forEach { role in
        
            out.append(UIAction(title: role.name ,handler: changeNameClosure))
        }
        return out
    }
}
