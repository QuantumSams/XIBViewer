import UIKit

final class LogInVC: UIViewController, UITextFieldDelegate{
    //property
    private let tableForm = TableForm.login.getForm
    private let tableOrder = TableForm.login.order
    private var isLoading: Bool = false {
        didSet{
            loginButton.setNeedsUpdateConfiguration()
        }
    }
    
    //Outlet
    @IBOutlet weak var loginButton:    UIButton!
    @IBOutlet weak var loginTableForm: UITableView!
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    //Action - event processing
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        TableFormCellModel.forceTableFormFieldToResign(count: tableForm.count, table: loginTableForm)
        callLogInAPI()
    }
}

//Setup view
extension LogInVC{
    private func setupViews(){
        setupButton(loginButton)
        setupTableForm(for: loginTableForm)
    }
    
    private func setupTextField(_ customTextField:UITextField){
        customTextField.delegate = self
        customTextField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        customTextField.layer.borderColor = UIColor.systemBlue.cgColor
        customTextField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        customTextField.layer.masksToBounds = true
        customTextField.borderStyle = .roundedRect
        
        NSLayoutConstraint.activate([customTextField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
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
    
    private func setupTableForm(for tableForm:UITableView){
        loginTableForm.delegate = self
        loginTableForm.dataSource = self
        loginTableForm.register(TextFormCell.nib, forCellReuseIdentifier: TextFormCell.id)
    }
}

// Managing Table form
extension LogInVC: UITableViewDelegate, UITableViewDataSource{
    func getDataFromTableFields() -> LoginModel?{
        guard let email = tableForm["Email"]?.value,
              let password = tableForm["Password"]?.value
        else{
            return nil
        }
        
        return LoginModel(email: email as! String, password: password as! String)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableForm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let field =  tableForm[tableOrder[indexPath.row]]  else{
            fatalError("cannot get field in tableForm for key tableOrder")
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TextFormCell.id,
            for: indexPath) as? TextFormCell
        else{
            fatalError("Cannot dequeue cell in SignUpVC")
        }
        
        cell.setupCell(form: field as! TextFormCellModel)
        return cell
    }
}

//API Calls
extension LogInVC{
    private func checkAuthenToNavigate(token tokenData: SuccessLoginResponse){
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.afterLogin(token: tokenData) //explaination needed
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
