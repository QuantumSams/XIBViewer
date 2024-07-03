import UIKit



final class SignUpVC: UIViewController, TableFormPasswordDelegate, TableFromPopUpMenuDelegate{
    
    var tableFormFieldList: [TableFormCellModel] = TableForm.signup.getForm
    var isLoading: Bool = false {
        didSet{
            signUpButton.setNeedsUpdateConfiguration()
            changeToLoginButton.setNeedsUpdateConfiguration()
        }
    }
 
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var changeToLoginButton: UIButton!
    
    @IBOutlet weak var tableField: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(for: tableField)
        setupViews()
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        callSignUpAPI()
    }
    @IBAction func loginOptionTapped(_ sender: UIButton) {
        navigateToCustomViewController(toViewController: LogInVC())
    }
}

// Setup view
extension SignUpVC {
    private func setupViews() {
        setupButton(signUpButton)
        setupButton(changeToLoginButton)
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
}
// Retrive data from fields
extension SignUpVC{
    private func getDataFromTableFields() -> SignupModel?{
        guard let name = tableFormFieldList[0].value,
              let email = tableFormFieldList[1].value,
              let password = tableFormFieldList[2].value,
              let roleID = tableFormFieldList[4].value
        else {
            return nil
        }
        return SignupModel(
            name: name as! String,
            email: email as! String ,
            role: roleID as! Int,
            password: password as! String)
    }
}


// Create API calls
extension SignUpVC{
    private func navigateToCustomViewController(toViewController: UIViewController) {
        navigationController?.pushViewController(toViewController, animated: true)
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
        
        AuthService.signUp(request: request) { result in
            switch result {
            case .success(_):
                self.loginAftersignUp(email: signUpData.email, password: signUpData.password)
            case .failure(let errorData):
                DispatchQueue.main.async {
                    self.isLoading = false
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
        
        switch tableFormFieldList[indexPath.row].fieldType{
            
        case .name, .email, .password, .confirmPassword, .custom:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TextFormCell.id,
                for: indexPath) as? TextFormCell
            else{
                fatalError("Cannot dequeue cell in SignUpVC")
            }
            
            cell.passwordDelegate = self
            cell.setupCell(form: tableFormFieldList[indexPath.row] as! TextFormCellModel)
            return cell
        
        case .roleSelection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopupButtonFormCell.id, for: indexPath) as? PopupButtonFormCell else{
                fatalError("Cannot dequeue cell in SignUpVC")
            }
            cell.delegate = self
            cell.setupCell(formType: tableFormFieldList[indexPath.row] as! PopupButtonFormCellModel)
            return cell
        }
        
       
    }
    
    private func setupTableView(for table:UITableView){
        table.dataSource = self
        table.delegate = self
        table.register(TextFormCell.nib, forCellReuseIdentifier: TextFormCell.id)
        table.register(PopupButtonFormCell.nib, forCellReuseIdentifier: PopupButtonFormCell.id)
    }
}

//Protocol methods - manage communication with table form cell
extension SignUpVC{
    func TableFormPasswordCollector(from passwordField: TextFormCellModel? = nil) -> String?{
        let passwordField = passwordField ?? tableFormFieldList[2]
        return passwordField.value as? String
    }
    
    func TableFormPopUpMenuConstructor(from literalStringChoices: [String], actionWhenChoiceChanged: @escaping UIActionHandler) -> UIMenu{
        
        var toReturn: [UIAction] = []
        
        literalStringChoices.forEach({ choice in
            toReturn.append(UIAction(title: choice, handler: actionWhenChoiceChanged))
        })
        
        return UIMenu(children: toReturn)
    }
}
