protocol EditVCDelegate{
    func doneEditing(send newUserData: UserModel)
}
import UIKit

class EditVC: UIViewController {
    
    // MARK: - VARIABLES
    private let viewModel: EditVM
    
    // MARK: - OUTLETS
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!

    // MARK: - LIFECYCLE
    init(existingData: UserModel, delegate: EditVCDelegate) {
        self.viewModel = EditVM(data: existingData, delegate: delegate)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setInitalValueForEditField(from: viewModel.existingData)
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
    
    func setInitalValueForEditField(from data: UserModel?){
        guard let data = data else{
            return
        }
        emailField.placeholder = data.email
        nameField.placeholder = data.name
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
                viewModel.name = nil
            }
            else{
                viewModel.name = value
            }
            
        case FieldIdentifier.email.rawValue:
            if let validationResult = Validator.validateEmail(for: value){
                emailValidationLabel.text = validationResult
                viewModel.email = nil
            }
            else{
                viewModel.email = value
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
    
    private func editUserRequest(){
        
        
        viewModel.sendData {[weak self] result in
            guard let self = self else {return}
            self.startIndicatingActivity()
            switch result{
        case .success():
            self.dismiss(animated: true, completion: nil)
        case .failure(let error):
                guard let error = error as? APIErrorTypes else {return}
                AlertManager.alertOnAPIError(with: error, on: self)
            }
            self.stopIndicatingActivity()
        }
    }
}
