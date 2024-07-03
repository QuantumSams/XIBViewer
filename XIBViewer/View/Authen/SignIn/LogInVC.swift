import UIKit

final class LogInVC: UIViewController{

    //property
    private let tableForm = TableForm.login.getForm
    
    //Outlet
//    @IBOutlet private weak var passwordField: UITextField!
//    @IBOutlet private weak var usernameField: UITextField!
//    @IBOutlet private weak var loginButton: UIButton!
//    
//    @IBOutlet private weak var loginTableField: UITableView!
    
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginTableField: UITableView!
    
    
    //Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //Action - event processing
   
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        sendLoginRequest()
    }
}


extension LogInVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableForm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TextFormCell.id,
            for: indexPath) as? TextFormCell
        else{
            fatalError("Cannot dequeue cell in SignUpVC")
        }
        return cell
    }
}


extension LogInVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


extension LogInVC{
    private func setupViews(){
        setupTextField(usernameField)
        setupTextField(passwordField)
        setupButton(loginButton)
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
    }
    
    private func checkAuthenToNavigate(){
        
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.checkAuthen() //explaination needed
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func sendLoginRequest(){
        let loginRequestData =
        LoginModel(email: usernameField.text ?? "",
                   password: passwordField.text ?? "")
        
        
        guard let request = Endpoints.login(model: loginRequestData).request else {
            //TODO: HANDLE
            return
        }
        
        AuthService.login(request: request) {result in
            switch result{
            case .success(_):
                self.checkAuthenToNavigate()
                
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

