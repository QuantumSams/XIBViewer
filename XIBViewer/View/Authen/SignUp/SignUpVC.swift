import UIKit


protocol cellCommunicationDelegate{
    func setData(id: String, value: String) -> Void
    func getPassword(from passwordField: TextFieldComponent?) -> String?
}

final class SignUpVC: UIViewController, cellCommunicationDelegate{
    var sample: TableForm = TableForm(formOrder: [
        TextFieldComponent(fieldType: .name, fieldPlaceholder: "Name", validationMethod: Validator.validateName),
        TextFieldComponent(fieldType: .email, fieldPlaceholder: "Email", validationMethod: Validator.validateEmail),
        TextFieldComponent(fieldType: .password, fieldPlaceholder: "Password", validationMethod: Validator.validatePasswordSingle),
        TextFieldComponent(fieldType: .confirmPassword, fieldPlaceholder: "Confirm password", validationMethod: Validator.validatePasswordSingle)
        ]
    )
 
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var changeToLoginButton: UIButton!
    @IBOutlet private weak var roleSelection: UIButton!
    

    @IBOutlet weak var tableField: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(for: tableField)
        setupViews()
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        navigateToTabBarController()
    }
    @IBAction func loginOptionTapped(_ sender: UIButton) {
        navigateToCustomViewController(toViewController: SignInVC())
    }
}

extension SignUpVC {
    private func setupViews() {
        setupButton(signUpButton)
        setupButton(changeToLoginButton)
        setupPopUpButton(for: roleSelection)
    }
    
    private func setupButton(_ button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: Constant.ButtonConstant.heightAnchor)])
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
        guard let selectedTitle = roleSelection.menu?.selectedElements.first?.title,
              let name = sample.getValue(id: sample.formOrder[0].id),
              let email = sample.getValue(id: sample.formOrder[1].id),
              let password = sample.getValue(id: sample.formOrder[2].id)
        else {
            return
        }
        
        guard let selectedID = RoleSingleton.accessSingleton.getID(from: selectedTitle) else{
            print("Cannot get id from popup menu")
            return
        }
        
        
        let signUpData = SignupModel(
            name: name as! String,
            email: email as! String ,
            role: selectedID,
            password: password as! String)
    
        
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
}

extension SignUpVC:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sample.formOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TextFieldTableViewCell.id,
            for: indexPath) as? TextFieldTableViewCell
        else{
            fatalError("Cannot dequeue cell in SignUpVC")
        }
        
        cell.delegate = self
        cell.setupCell(form: sample.formOrder[indexPath.row] as! TextFieldComponent)
        return cell
    }
    
    private func setupTableView(for table:UITableView){
        table.dataSource = self
        table.delegate = self
        table.register(TextFieldTableViewCell.nib, forCellReuseIdentifier: TextFieldTableViewCell.id)
    }
    
    func setData(id: String, value: String){
        sample.setValue(id: id, value: value)
    }
    
    func getPassword(from passwordField: TextFieldComponent? = nil) -> String?{
        let passwordField = passwordField ?? sample.formOrder[2]
        let passwordString = sample.getValue(id: passwordField.id) as? String
        return passwordString
    }
}
