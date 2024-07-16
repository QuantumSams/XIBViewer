import UIKit

final class LogInVC: UIViewController {
    // MARK: - PROPERTY

    private var isLoading: Bool = false {
        didSet {
            loginButton.setNeedsUpdateConfiguration()
        }
    }
    private let viewModel: LogInVM
    
    // MARK: - IBOUTLETS

    @IBOutlet var loginButton: UIButton!
    
    // Fields
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    
    // Label
    @IBOutlet private var emailValidationLabel: UILabel!
    @IBOutlet private var passwordValidationLabel: UILabel!
    
    // MARK: - Lifecycle
    
    init() {
        self.viewModel = LogInVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - event catching

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        logInRequest()
    }
}

// MARK: - DELEGATE/DATASOURCE CONFORM

extension LogInVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text ?? ""
        switch textField.tag {
        case FieldIdentifier.email.rawValue:
            
            if let validationResponse = Validator.isDataEmpty(for: textField.text) {
                emailValidationLabel.text = validationResponse
                viewModel.email = nil
            }
            else {
                viewModel.email = textField.text
            }
            
        case FieldIdentifier.password.rawValue:
            if let validationResponse = Validator.isDataEmpty(for: textField.text) {
                passwordValidationLabel.text = validationResponse
                viewModel.password = nil
            }
            else {
                viewModel.password = textField.text
            }

        default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case FieldIdentifier.email.rawValue:
            emailValidationLabel.text = ""
            
        case FieldIdentifier.password.rawValue:
            passwordValidationLabel.text = ""

        default: break
        }
        return true
    }
}

// MARK: - ADDITIONAL METHODS

// setup view
extension LogInVC {
    private func setupViews() {
        setupButton(loginButton)
        
        setupTextField(emailField)
        setupTextField(passwordField)
        setupFieldIdentifier()
        
        setupValidationLabel(emailValidationLabel)
        setupValidationLabel(passwordValidationLabel)
    }
    
    private func setupTextField(_ textField: UITextField) {
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.borderColor = Constant.TextBoxConstant.borderColor.cgColor
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        textField.backgroundColor = Constant.TextBoxConstant.backgroundColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.size.height))
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
        
        textField.delegate = self
    }
    
    private func setupFieldIdentifier() {
        emailField.tag = FieldIdentifier.email.rawValue
        passwordField.tag = FieldIdentifier.password.rawValue
    }
    
    private func setupValidationLabel(_ label: UILabel) {
        label.text = ""
    }
    
    private func setupButton(_ customButton: UIButton) {
        customButton.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        customButton.layer.masksToBounds = true

        NSLayoutConstraint.activate([customButton.heightAnchor.constraint(equalToConstant: Constant.ButtonConstant.heightAnchor)])

        customButton.configurationUpdateHandler = { [weak self] button in
            guard let self = self else {return}
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            button.configuration = config
            button.isEnabled = !self.isLoading
        }
    }
}

// API Calls
extension LogInVC {
    private func logInRequest() {
        isLoading = true
        viewModel.requestLogInAPI { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.swapRootVC(SettingTabBarVC(), transition: true)
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else { return }
                    AlertManager.alertOnAPIError(with: error, on: self)
                }
                self.isLoading = false
            }
        }
    }
}
