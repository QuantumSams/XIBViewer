protocol EditVCDelegate{
    func doneEditing(send newUserData: UserModel)
}

import UIKit

class EditVC: UIViewController {
    
    // MARK: - VARIABLES
    private let existingData: UserModel?
    private var name: String?
    private var email: String?
    
    var delegate: EditVCDelegate?
    
    // MARK: - OUTLETS
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!

    // MARK: - LIFECYCLE
    init(existingData: UserModel?) {
        self.existingData = existingData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setInitalValueForEditField(from: existingData)
    }
    
    //MARK: - EVENT CATCHING
    @objc private func cancelButtonSelected(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonPressed(){
        self.view.endEditing(true)
        editUserRequest()
    }
}

//MARK: - ADDITIONAL METHODS
// Setup view
extension EditVC{
    private func setup(){
        self.title = "Update information"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonSelected))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
        
        setupTextField(emailField)
        setupTextField(nameField)
        setupFieldIdentifier()
        
        setupValidationLabel(for: emailValidationLabel)
        setupValidationLabel(for: nameValidationLabel)
    }
    
    private func setupTextField(_ textField:UITextField){
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
        nameField.tag = FieldIdentifier.name.rawValue
        emailField.tag = FieldIdentifier.email.rawValue
    }
    
    private func setupValidationLabel(for label: UILabel){
        label.text = ""
    }
}

// Validation handling
extension EditVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = textField.text ?? ""
        
        switch textField.tag{
        case FieldIdentifier.name.rawValue:
            if let validationResult = Validator.validateName(for: value){
                nameValidationLabel.text = validationResult
                name = nil
            }
            else{
                name = value
            }
            
        case FieldIdentifier.email.rawValue:
            if let validationResult = Validator.validateEmail(for: value){
                emailValidationLabel.text = validationResult
                email = nil
            }
            else{
                email = value
            }
            
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag{
        case FieldIdentifier.name.rawValue:
            nameValidationLabel.text = ""
            
        case FieldIdentifier.email.rawValue:
            nameValidationLabel.text = ""
            
        default: break
        }
        
        return true
    }
}
//API calling
extension EditVC{
    func setInitalValueForEditField(from data: UserModel?){
        guard let data = data else{
            return
        }
        emailField.placeholder = data.email
        nameField.placeholder = data.name
    }
    
    private func getFieldData() -> PUTMethodUserModel?{
        
        guard let email = email,
              let name =  name,
              let selectedRole = existingData?.role.name
        else{
           return nil
        }
        
        print()
        
        return PUTMethodUserModel(name: name,
                                  email: email,
                                  role: PUTMethodRoleModel(name: selectedRole))
    }
    
    private func editUserRequest(){
        guard delegate != nil else{
            fatalError("EditRefreshDataDelegate hasn't been assigned")
        }
        
        guard let editData = getFieldData() else{
            AlertManager.FormNotCompleted(on: self)
            return
        }
        
        guard let userID = existingData?.id else{
            fatalError("user id is nil")
        }
        
        guard let request = Endpoints.editUser(model: editData, id: userID).request else{
            return
        }
        self.startIndicatingActivity()
        AccountService.editAccount(request: request) {[weak self] result in
            switch result{
            case .success(let newUserData):
                self!.delegate!.doneEditing(send: newUserData)
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                    guard let error = error as? APIErrorTypes else {return}
                    switch error{
                    case .deviceError(let string):
                        AlertManager.showDeviceError(on: self!, message: string)
                    case .serverError(let string):
                        AlertManager.showServerErrorResponse(on: self!, message: string)
                    case .decodingError(let string):
                        AlertManager.showDevelopmentError(on: self!, message: string, errorType: .decodingError())
                    case .unknownError(let string):
                        AlertManager.showDevelopmentError(on: self!, message: string, errorType: .unknownError())
                    }
                }
            }
        }
    }
}
