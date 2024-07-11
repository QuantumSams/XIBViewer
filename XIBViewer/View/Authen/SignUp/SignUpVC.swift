import UIKit

final class SignUpVC: UIViewController{
    
    // MARK: - Variables
    private var isLoading: Bool = false {
        didSet{
            signUpButton.setNeedsUpdateConfiguration()
            changeToLoginButton.setNeedsUpdateConfiguration()
        }
    }
    private var email:      String?
    private var name:       String?
    private var password:   String?
    private var role:       RoleModel?
 
    //MARK: - IB Components
    
    //Fields
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    
    //Validation labels
    @IBOutlet private weak var nameValidationLabel: UILabel!
    @IBOutlet private weak var emailValidationLabel: UILabel!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var confirmPasswordValidationLabel: UILabel!
    
    // Buttons
    @IBOutlet private weak var roleSelectionButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var changeToLoginButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestRoleAPI()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Event catching
    @IBAction func registerTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        requestSignUpAPI()
    }
    @IBAction func loginOptionTapped(_ sender: UIButton) {
        pushToCustomVC(toVC: LogInVC())
    }
    
    private func popUpButtonSeletedChoice() -> (UIAction) -> Void{
       return { selected in
            self.role = RoleModel(id: Int(selected.identifier.rawValue) ?? -1,
                                             name: selected.title)
        }
    }
}

//MARK: - Additional methods

//Setup UI
extension SignUpVC{
    private func setupViews() {
        setupTextField(nameField)
        setupTextField(emailField)
        setupTextField(passwordField)
        setupTextField(confirmPasswordField)
        setupFieldIdentifier()
                
        setupLabel(for: nameValidationLabel)
        setupLabel(for: emailValidationLabel)
        setupLabel(for: passwordValidationLabel)
        setupLabel(for: confirmPasswordValidationLabel)

        setupButton(signUpButton)
        setupButton(changeToLoginButton)
    }
    
    private func setupFieldIdentifier(){
        nameField.tag               = FieldIdentifier.name.rawValue
        emailField.tag              = FieldIdentifier.email.rawValue
        passwordField.tag           = FieldIdentifier.password.rawValue
        confirmPasswordField.tag    = FieldIdentifier.confirmPassword.rawValue
    }
    
    private func setupLabel(for label:UILabel){
        label.text = ""
    }
    
    func setPopUpButtonData(for button: UIButton, with roles: [RoleModel], and handler: @escaping UIActionHandler){
        var actions: [UIAction] = []
        for role in roles{
            actions.append(UIAction(title: role.name,
                                    identifier: .init(String(role.id)),
                                    handler: handler)
            )
        }

        button.menu = UIMenu(children: actions)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        
        if let currentSelected = button.menu?.selectedElements.first as? UIAction{
            
            self.role = RoleModel(id: Int(currentSelected.identifier.rawValue) ?? -1,
                                  name: currentSelected.title)
        }
        
    }
    
    private func setupButton(_ button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: Constant.ButtonConstant.heightAnchor)])
        
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            button.configuration = config
            button.isEnabled = !self.isLoading
        }
    }
    
    private func setupTextField(_ textField: UITextField) {
        textField.delegate = self
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.borderColor = Constant.TextBoxConstant.borderColor.cgColor
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        textField.backgroundColor = Constant.TextBoxConstant.backgroundColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.size.height))
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
        
        textField.delegate = self
    }
}

// Text validation
extension SignUpVC: UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text ?? ""
        switch textField.tag{
            
        case FieldIdentifier.name.rawValue:
            if let validateResponse = Validator.validateName(for: textField.text) {
                nameValidationLabel.text = validateResponse
                name = nil
            }
            else{
                name = textField.text
            }
    
        case FieldIdentifier.email.rawValue:
            if let validateResponse = Validator.validateEmail(for: textField.text){
                emailValidationLabel.text = validateResponse
                email = nil
            }
            else{
                email = textField.text
            }
            
            
        case FieldIdentifier.password.rawValue:
            if let validateResponse = Validator.validatePassword(for: textField.text){
                passwordValidationLabel.text = validateResponse
                password = nil
            }
            
        case FieldIdentifier.confirmPassword.rawValue:
            if let validateResponse = Validator.comparePassword(password: passwordField.text,
                                                                confirmPassword: confirmPasswordField.text){
                confirmPasswordValidationLabel.text = validateResponse
                confirmPasswordValidationLabel.isHidden = false
                password = nil
            }
            else{
                password = textField.text
            }
            
        default:
            break
        }
    return true
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag{
        case FieldIdentifier.name.rawValue:
            nameValidationLabel.text = ""
            
        case FieldIdentifier.email.rawValue:
            emailValidationLabel.text = ""

        case FieldIdentifier.password.rawValue:
            passwordValidationLabel.text = ""
            
        case FieldIdentifier.confirmPassword.rawValue:
            confirmPasswordValidationLabel.text = ""
            
        default:
            break
        }
        return true
    }
    
}

//API requests
extension SignUpVC{
    
    private func getDataFromTableFields() -> SignupModel?{
        guard let name: String = name,
              let email: String = email,
              let password: String = password,
              let role: RoleModel = role,
              role.id != -1
        else {
            return nil
        }
        return SignupModel(
            name: name,
            email: email,
            role: role.id,
            password: password
        )
    }
    
    private func requestSignUpAPI(){
        guard let signUpData = getDataFromTableFields() else{
            AlertManager.showAlert(on: self, 
                                   title: "Form not completed",
                                   message: "Please check the sign up form again.")
            return
        }
        isLoading = true

        guard let request = Endpoints.signup(model: signUpData).request else{
            AlertManager.showAlert(on: self, title: "Something went wrong", message: "Please try again (Cannot create request from data - SignUpVC - requestSignUpAPI())")
            return
        }
        
        AuthService.signUp(request: request) {[weak self] result in
            switch result {
            case .success(_):
                self?.loginAftersignUp(email: signUpData.email, password: signUpData.password)
            case .failure(let errorData):
                DispatchQueue.main.async {
                    self?.isLoading = false
                guard let errorData = errorData as? APIErrorTypes else {return}
                switch errorData{
                case .serverError(let string):
                    AlertManager.showServerErrorResponse(on: self!, message: string)
                case .decodingError(let string):
                    AlertManager.showDevelopmentError(on: self!, message: string, errorType: .decodingError())
                case  .unknownError(let string):
                    AlertManager.showDevelopmentError(on: self!, message: string, errorType: .unknownError())
                case .deviceError(let string):
                    AlertManager.showDeviceError(on: self!, message: string)
                }
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
            case .success(let tokenData):

                
                DispatchQueue.main.async {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.afterLogin(token: tokenData)
                }

            case .failure(let error):
                guard let error = error as? APIErrorTypes else {return}
                DispatchQueue.main.async {
                    self.isLoading = false
                }
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
    
    private func requestRoleAPI(){
        self.startIndicatingActivity()
        RoleService.getRole { result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self.setPopUpButtonData(for: self.roleSelectionButton,
                                             with: data.results,
                                             and: self.popUpButtonSeletedChoice())
                    self.stopIndicatingActivity()
                }
            case .failure(let error):
                guard let error = error as? APIErrorTypes else {return}
                DispatchQueue.main.async { [weak self] in
                    self?.stopIndicatingActivity()
                }
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
}





