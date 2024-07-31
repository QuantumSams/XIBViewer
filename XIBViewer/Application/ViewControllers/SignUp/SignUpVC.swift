import UIKit

final class SignUpVC: UIViewController {
    // MARK: - Variables

    private var isLoading: Bool = false {
        didSet {
            signUpButton.setNeedsUpdateConfiguration()
            changeToLoginButton.setNeedsUpdateConfiguration()
        }
    }

    private let viewModel: SignUpVM
 
    // MARK: - IB Components
    
    // Fields
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var confirmPasswordField: UITextField!
    
    // Validation labels
    @IBOutlet private var nameValidationLabel: UILabel!
    @IBOutlet private var emailValidationLabel: UILabel!
    @IBOutlet private var passwordValidationLabel: UILabel!
    @IBOutlet private var confirmPasswordValidationLabel: UILabel!
    
    // Buttons
    @IBOutlet private var roleSelectionButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var changeToLoginButton: UIButton!
    
    // MARK: - Lifecycle
    
    init() {
        self.viewModel = SignUpVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialAuthenCheck()
    }
    
    // MARK: - Event catching

    @IBAction func registerTapped(_ sender: UIButton) {
        view.endEditing(true)
        signUpAction()
    }

    @IBAction func loginOptionTapped(_ sender: UIButton) {
        pushToCustomVC(toVC: LogInVC())
    }
    
    private func popUpButtonSeletedChoice() -> (UIAction) -> Void {
        return { selected in
            self.viewModel.role = RoleModel(id: Int(selected.identifier.rawValue) ?? -1,
                                            name: selected.title)
        }
    }
}

// MARK: - Delegate/Datasource conform

// UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text ?? ""
        switch textField.tag {
        case FieldIdentifier.name.rawValue:
            if let validateResponse = Validator.validateName(for: textField.text) {
                nameValidationLabel.text = validateResponse
                viewModel.name = nil
            }
            else {
                viewModel.name = textField.text
            }
            
        case FieldIdentifier.email.rawValue:
            if let validateResponse = Validator.validateEmail(for: textField.text) {
                emailValidationLabel.text = validateResponse
                viewModel.email = nil
            }
            else {
                viewModel.email = textField.text
            }
            
        case FieldIdentifier.password.rawValue:
            if let validateResponse = Validator.validatePassword(for: textField.text) {
                passwordValidationLabel.text = validateResponse
                viewModel.password = nil
            }
            
        case FieldIdentifier.confirmPassword.rawValue:
            if let validateResponse = Validator.comparePassword(password: passwordField.text,
                                                                confirmPassword: confirmPasswordField.text)
            {
                confirmPasswordValidationLabel.text = validateResponse
                confirmPasswordValidationLabel.isHidden = false
                viewModel.password = nil
            }
            else {
                viewModel.password = textField.text
            }
            
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
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

// MARK: - Additional methods

// Setup UI
extension SignUpVC {
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
    
    private func setupFieldIdentifier() {
        nameField.tag = FieldIdentifier.name.rawValue
        emailField.tag = FieldIdentifier.email.rawValue
        passwordField.tag = FieldIdentifier.password.rawValue
        confirmPasswordField.tag = FieldIdentifier.confirmPassword.rawValue
    }
    
    private func setupLabel(for label: UILabel) {
        label.text = ""
    }
    
    private func setPopUpButtonData(for button: UIButton, with roles: [RoleModel], and handler: @escaping UIActionHandler) {
        var actions: [UIAction] = []
        for role in roles {
            actions.append(UIAction(title: role.name,
                                    identifier: UIAction.Identifier(rawValue: String(role.id)),
                                    handler: handler)
            )
        }

        button.menu = UIMenu(children: actions)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        if let currentSelected = button.menu?.selectedElements.first as? UIAction {
            viewModel.role = RoleModel(id: Int(currentSelected.identifier.rawValue) ?? -1,
                                       name: currentSelected.title)
        }
    }
    
    private func setupButton(_ button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: Constant.ButtonConstant.heightAnchor)])
        
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
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

// API requests
extension SignUpVC {
    private func getDataFromTableFields() -> SignUpDTO? {
        guard let name: String = viewModel.name,
              let email: String = viewModel.email,
              let password: String = viewModel.password,
              let role: RoleModel = viewModel.role,
              role.id != -1
        else {
            return nil
        }
        return SignUpDTO(
            name: name,
            email: email,
            role: role.id,
            password: password
        )
    }
    
    private func signUpAction() {
        isLoading = true
        viewModel.requestSignUpAPI { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success:
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.swapRootVC(SettingTabBarVC(), transition: true)
                case .failure(let error):
                    self.isLoading = false
                    guard let error = error as? APIErrorTypes else { return }
                    switch error {
                    case .deviceError(let err):
                        AlertManager.retryAPICall(on: self, message: err) {
                            self.signUpAction()
                        }
                    default:
                        AlertManager.alertOnAPIError(with: error, on: self)
                    }
                }
            }
        }
    }
    
    private func getRoleAction() {
        startIndicatingActivity()
        viewModel.requestRoleAPI { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.setPopUpButtonData(for: self.roleSelectionButton,
                                                with: self.viewModel.roleSelectionMenu ?? [],
                                                and: self.popUpButtonSeletedChoice())
                        self.stopIndicatingActivity()
                    }
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else { return }
                    self.stopIndicatingActivity()
                    
                    switch error {
                    case .deviceError(let err):
                        AlertManager.retryAPICall(on: self, message: err) {
                            self.getRoleAction()
                        }
                    default:
                        AlertManager.alertOnAPIError(with: error, on: self)
                    }
                }
            }
        }
    }
    
    private func initialAuthenCheck() {
        startIndicatingActivity(isFullScreen: true)
        viewModel.requestRefreshToken { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.stopIndicatingActivity()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.swapRootVC(SettingTabBarVC(), transition: false)
                case .failure(let error):
                    self.stopIndicatingActivity()
                    guard let error = error as? APIErrorTypes else { return }
                    switch error {
                    case .unauthorized:
                        self.getRoleAction()
                        
                    case .deviceError(let err):
                        AlertManager.retryAPICall(on: self, message: err) {
                            self.initialAuthenCheck()
                        }

                    default:
                        AlertManager.alertOnAPIError(with: error, on: self)
                    }
                }
            }
        }
    }
}
