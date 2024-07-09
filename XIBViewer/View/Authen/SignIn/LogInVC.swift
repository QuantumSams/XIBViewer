import UIKit

final class LogInVC: UIViewController{
    // MARK: - PROPERTY
    private var isLoading: Bool = false {
        didSet{
            loginButton.setNeedsUpdateConfiguration()
        }
    }
    private var password:   String?
    private var email:      String?
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var loginButton: UIButton!
    
    //Fields
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    //Label
    @IBOutlet private weak var emailValidationLabel: UILabel!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    //MARK: - event catching
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        callLogInAPI()
    }
}
//MARK: - ADDITIONAL METHODS

//setup view
extension LogInVC{
    private func setupViews(){
        setupButton(loginButton)
        
        setupTextField(emailField)
        setupTextField(passwordField)
        setupFieldIdentifier()
        
        setupValidationLabel(emailValidationLabel)
        setupValidationLabel(passwordValidationLabel)
        
    }
    
    private func setupTextField(_ textField:UITextField){
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
    
    private func setupFieldIdentifier(){
        emailField.tag = FieldIdentifier.email.rawValue
        passwordField.tag = FieldIdentifier.password.rawValue
    }
    
    private func setupValidationLabel(_ label: UILabel){
        label.text = ""
    }
    
    private func setupButton(_ customButton: UIButton){
        customButton.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        customButton.layer.masksToBounds = true

        NSLayoutConstraint.activate([customButton.heightAnchor.constraint(equalToConstant: Constant.ButtonConstant.heightAnchor)])
                
        customButton.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            button.configuration = config
            button.isEnabled = !self.isLoading
        }
    }
}
// Text field validation
extension LogInVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text ?? ""
        switch textField.tag{
        case FieldIdentifier.email.rawValue:
            
            if let validationResponse = Validator.isDataEmpty(for: textField.text){

                emailValidationLabel.text = validationResponse
                email = nil
                
            }
            else {
                email = textField.text
            }
            
        case FieldIdentifier.password.rawValue:
            if let validationResponse = Validator.isDataEmpty(for: textField.text){
                passwordValidationLabel.text = validationResponse
                password = nil
            }
            else{
                password = textField.text
            }
        default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag{
        case FieldIdentifier.email.rawValue:
            emailValidationLabel.text = ""
            
        case FieldIdentifier.password.rawValue:
            passwordValidationLabel.text = ""
        default: break
        }
        return true
    }
}

//API Calls
extension LogInVC{
    func getDataFromTableFields() -> LoginModel?{
        guard let email = email,
              let password = password
        else{
            return nil
        }
        return LoginModel(email: email, password: password)
    }
    
    private func checkAuthenToNavigate(token tokenData: SuccessLoginResponse){
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.afterLogin(token: tokenData)
        }
       }
    
    private func callLogInAPI(){
        
        isLoading = true
        guard let loginRequestData = getDataFromTableFields() else{
            AlertManager.showAlert(on: self,
                                   title: "Form not complete",
                                   message: "Please check the sign in form again.")
            isLoading = false
            return
        }
        guard let request = Endpoints.login(model: loginRequestData).request else {
            //TODO: HANDLE
            return
        }
        
        AuthService.login(request: request) {result in
            switch result{
            case .success(let tokenData):
                self.checkAuthenToNavigate(token: tokenData)
                
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
                DispatchQueue.main.sync {
                    self.isLoading = false
                }
            }
        }
    }
}
