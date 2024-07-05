import UIKit

final class SignUpVC: UIViewController, TableFormPasswordDelegate, TableFromPopUpMenuDelegate{
    
    private let tableFormFieldList: [String:TableFormCellModel] = TableForm.signup.getForm
    private let tableFormOrder: [String] = TableForm.signup.order
    private var isLoading: Bool = false {
        didSet{
            signUpButton.setNeedsUpdateConfiguration()
            changeToLoginButton.setNeedsUpdateConfiguration()
        }
    }
 
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
extension SignUpVC {
    private func setupViews() {
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
}

// Get data from all field + Create API calls
extension SignUpVC{
    private func navigateToCustomViewController(toViewController: UIViewController) {
        navigationController?.pushViewController(toViewController, animated: true)
    }
    
    private func getDataFromTableFields() -> SignupModel?{
        guard let name = tableFormFieldList["Name"]?.value,
              let email = tableFormFieldList["Email"]?.value,
              let password = tableFormFieldList["Password"]?.value,
              let roleID = tableFormFieldList["Role"]?.value
        else {
            return nil
        }
        return SignupModel(
            name: name as! String,
            email: email as! String ,
            role: roleID as! Int,
            password: password as! String)
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
                
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.afterLogin(token: tokenData) //explaination needed
                
                
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
            cell.delegate = self
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
    
    func TableFormPopUpMenuConstructor(from literalStringChoices: [String], actionWhenChoiceChanged: @escaping UIActionHandler) -> UIMenu{
        
        var toReturn: [UIAction] = []
        
        literalStringChoices.forEach({ choice in
            toReturn.append(UIAction(title: choice, handler: actionWhenChoiceChanged))
        })
        
        return UIMenu(children: toReturn)
    }
}
