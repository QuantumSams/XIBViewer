import UIKit


final class SignUpVC: UIViewController{
    
    
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var fullNameField: UITextField!
    @IBOutlet private weak var changeToLoginButton: UIButton!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var roleSelection: UIButton!
    @IBOutlet private weak var emailField: UITextField!
    
    @IBOutlet weak var tableField: UITableView!
    
    
    
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var confirmPasswordValidationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(for: tableField)
        setupViews()
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        signUpButton.configuration?.showsActivityIndicator = true
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
            popUpButton.menu = UIMenu(children:
                                        RoleSingleton.accessSingleton.convertToUIAction(
                                            handler: self.whenPopUpButtonChanges()
                                        )
            )

            popUpButton.showsMenuAsPrimaryAction = true
            popUpButton.changesSelectionAsPrimaryAction = true
            (popUpButton.menu?.children[0] as? UIAction)?.state = .on
        }
        
        
    }
    private func whenPopUpButtonChanges() -> (UIAction) -> Void{
        let changeNameClosure = {(incomingAction: UIAction) in
            //TODO: update to DB about role changes
        }
        return changeNameClosure
    }
    
}


extension SignUpVC{
    private func navigateToCustomViewController(toViewController: UIViewController) {
        navigationController?.pushViewController(toViewController, animated: true)
    }
    
    private func navigateToTabBarController(){
        guard let signUpData = validateData(name: fullNameField.text ?? "",
                                            email: emailField.text ?? "",
                                            password: passwordField.text ?? "", 
                                            confirmPassword: confirmPasswordField.text ?? "") 
        else {return}
        
        guard let request = Endpoints.signup(model: signUpData).request else{
            //TODO: HANDLE
            return
        }
        
        AuthService.signUp(request: request) { result in
            switch result {
            case .success(_):
                self.loginAftersignUp(email: signUpData.email, password: signUpData.password)
            case .failure(let errorData):
                guard let errorData = errorData as? APIErrorTypes else {return}
                switch errorData{
                case .serverError(let string):
                    AlertManager.showServerErrorResponse(on: self, message: string)
                case .decodingError(let string):
                    AlertManager.showDevelopmentError(on: self, message: string, errorType: .decodingError())
                case  .unknownError(let string):
                    AlertManager.showDevelopmentError(on: self, message: string, errorType: .unknownError())
                case .deviceError(let string):
                    AlertManager.showDeviceError(on: self, message: string)
                }
            }
        }
    }
    
    
    private func loginAftersignUp(email: String, password: String){
        let loginData = LoginModel(email: email, password: password)
        
        guard let request = Endpoints.login(model: loginData).request else{
            return
            //TODO: Handle
        }
        
        AuthService.login(request: request) { result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.checkAuthen() //explaination needed
                }
                
            case .failure(let error):
                guard let error = error as? APIErrorTypes else {return}
                
                switch error{
                case .serverError(let string):
                    AlertManager.showServerErrorResponse(on: self, message: string)
                case .decodingError(let string),
                        .unknownError(let string):
                    AlertManager.showDevelopmentError(on: self, message: string, errorType: .decodingError())
                case .deviceError(let string):
                    AlertManager.showDeviceError(on: self, message: string)
                }
            }
        }
        
    }
    
    private func validateData(name: String,
                              email: String,
                              password: String,
                              confirmPassword: String) -> SignupModel?
    {
        
        guard let selectedTitle = roleSelection.menu?.selectedElements.first?.title else{
            //TODO: Handle case
            AlertManager.showGenericError(on: self, message: "Development: Cannot select title from highlighted pop-up button (SignUpVC.swift)")
            return nil
        }
        
        guard let selectedRole = RoleSingleton.accessSingleton.getID(from: selectedTitle) else{
            //TODO: Handle case
            AlertManager.showGenericError(on: self, message: "Development: Cannot get role id from role title (SignUpVC.swift)")
            return nil
        }
        
        if let nameError = Validator.validateName(for: name){
            AlertManager.showAlert(on: self, title: "Name error", message: nameError)
            return nil
        }
        if let emailError = Validator.validateEmail(for: email){
            AlertManager.showAlert(on: self, title: "Email error", message: emailError)
            return nil
        }
        
        if let passwordError = Validator.validatePassword(for: password, and: confirmPassword){
            AlertManager.showAlert(on: self, title: "Password error", message: passwordError)
            return nil
        }
        
        return SignupModel(name: name, email: email, role: selectedRole, password: password)
    }
    
}

extension SignUpVC:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FieldTableViewCell.id,
            for: indexPath) as? FieldTableViewCell
        else{
            fatalError("Cannot dequeue cell in SignUpVC")
        }
        
        cell.setupCell(fieldPlaceholder: "Email", validationMethod: Validator.validateEmail)
        print(indexPath.row)
        return cell
    }
    
    
    private func setupTableView(for table:UITableView){
        table.dataSource = self
        table.delegate = self
        table.register(FieldTableViewCell.nib, forCellReuseIdentifier: FieldTableViewCell.id)
    }
}
