import UIKit

final class SignUpVC: UIViewController, TableFormPasswordDelegate{
    
    private let tableFormFieldList: [String:TableFormCellModel] = TableForm.signup.getForm
    private let tableFormOrder: [String] = TableForm.signup.order
    private var isLoading: Bool = false {
        didSet{
            signUpButton.setNeedsUpdateConfiguration()
            changeToLoginButton.setNeedsUpdateConfiguration()
        }
    }
 
    //Fields - role selection
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var roleSelectionButton: UIButton!
    
    //Validation labels
    
    @IBOutlet private weak var nameValidationLabel: UILabel!
    @IBOutlet private weak var emailValidationLabel: UILabel!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var confirmPasswordValidationLabel: UILabel!
    
    
    // Register/Login button
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var changeToLoginButton: UIButton!
    
    @IBOutlet weak var tableForm: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        TableFormCellModel.forceTableFormFieldToResign(count: tableFormOrder.count, table: tableForm)
        callSignUpAPI()
    }
    @IBAction func loginOptionTapped(_ sender: UIButton) {
        navigateToCustomViewController(toViewController: LogInVC())
    }
}

// Setup view
extension SignUpVC: UITextFieldDelegate {
    private func setupViews() {
        setupTextField(nameField)
        setupTextField(emailField)
        setupTextField(passwordField)
        setupTextField(confirmPasswordField)
        
        setupButton(signUpButton)
        setupButton(changeToLoginButton)
        setupTableView(for: tableForm)
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
    
    private func setupTableView(for table:UITableView){
        table.dataSource = self
        table.delegate = self
        table.register(TextFormCell.nib, forCellReuseIdentifier: TextFormCell.id)
        table.register(PopupButtonFormCell.nib, forCellReuseIdentifier: PopupButtonFormCell.id)
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
    }
}

// Get data from all field + Create API calls
extension SignUpVC{
    private func navigateToCustomViewController(toViewController: UIViewController) {
        navigationController?.pushViewController(toViewController, animated: true)
    }
    
    
    
    private func getDataFromTableFields() -> SignupModel?{
        guard let name: String = tableFormFieldList["Name"]?.value as? String,
              let email: String = tableFormFieldList["Email"]?.value as? String,
              let password: String = tableFormFieldList["Password"]?.value as? String,
              let selectedRole: RoleModel = tableFormFieldList["Role"]?.value as? RoleModel
        else {
            return nil
        }
        return SignupModel(
            name: name,
            email: email,
            role: selectedRole.id,
            password: password
        )
    }
    
    private func callSignUpAPI(){
        guard let signUpData = getDataFromTableFields() else{
            AlertManager.showAlert(on: self, title: "Form not completed",
                                   message: "Please check the sign up form again.")
            return
        }
        isLoading = true

        guard let request = Endpoints.signup(model: signUpData).request else{
            //TODO: HANDLE
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
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.afterLogin(token: tokenData) //explaination needed
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
}


//Manage Table form
extension SignUpVC:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableFormFieldList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let field = tableFormFieldList[tableFormOrder[indexPath.row]] else{
            fatalError("tableFormFieldList field of key tableFormOrder is nil")
        }
        
        switch field.fieldType{
            
        case .name, .email, .password, .confirmPassword, .custom:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TextFormCell.id,
                for: indexPath) as? TextFormCell
            else{
                fatalError("Cannot dequeue cell in SignUpVC")
            }
            
            cell.passwordDelegate = self
            cell.setupCell(form: field as! TextFormCellModel)
            return cell
        
        case .roleSelection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopupButtonFormCell.id, for: indexPath) as? PopupButtonFormCell else{
                fatalError("Cannot dequeue cell in SignUpVC")
            }
            cell.setupCell(formType: field as! PopupButtonFormCellModel)
            return cell
        }
    }
}

//Manage communication with table form cell
extension SignUpVC{
   
    
    
    func TableFormPasswordCollector(from passwordField: TextFormCellModel? = nil) -> String?{
        guard let passwordField = passwordField ?? tableFormFieldList["Password"] else{
            fatalError("passwordField not valid")
        }
        return passwordField.value as? String
    }
    
}
