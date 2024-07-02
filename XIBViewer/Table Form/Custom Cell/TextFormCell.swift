import UIKit

final class TextFormCell: UITableViewCell {
    
    static let id: String = "TextFormCell"
    static var nib: UINib {
        UINib(nibName: "TextFormCell", bundle: nil)
    }
    
    private var formType: TextFormCellModel?
    var delegate : cellCommunicationDelegate?
    

    @IBOutlet private weak var validationLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func fieldDidEdit(_ sender: UITextField) {
        determineTypeOfTextField()
    }
    
    @IBAction private func fieldEditing(_ sender: UITextField) {
        validationLabel.text = " \n"
    }
}

extension TextFormCell{
   
    func setupCell(form: TextFormCellModel){
        formType = form
        setupTextField(textField)
        setupKeyboardType(textField)
        validationLabel.text = " \n"
    }
}

extension TextFormCell: UITextFieldDelegate{
    private func setupTextField(_ textField: UITextField) {
        textField.delegate = self // explaination needed
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.borderColor = UIColor.systemIndigo.cgColor
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
        
        self.textField.placeholder = formType?.fieldPlaceholder
    }
    
    private func setupKeyboardType(_ textField: UITextField){
        textField.keyboardType = formType?.keyboardType ?? .default
        textField.isSecureTextEntry = formType?.secureEntry ?? false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}

extension TextFormCell{
    
    private func determineTypeOfTextField(){
        switch formType?.fieldType {
        case .confirmPassword:
            confirmPasswordEditComplete()
        default:
            editCompleted()
        }
    }
    
    private func editCompleted(){
        
        guard delegate != nil else{
            fatalError("Delegate has not been set")
        }
        
        guard let validationMethod = formType?.validationMethod else{
            print("Validation method is nil")
            return
        }
        
        guard let formType else{
            print("Type of form is nil")
            return
        }
        
        
        if let checkValid = validationMethod(textField.text ?? " "){
            print(checkValid)
            validationLabel.text = checkValid
            return
        }
        formType.value = textField.text
    }
    
    private func confirmPasswordEditComplete(){
        guard let delegate else{
            fatalError("Delegate is nil")
        }
        
        guard let formType else{
            fatalError("FormType is nil")
        }
        
        guard let passwordString = delegate.getPassword(from: nil) else{
            return
        }
        
        if (passwordString != textField.text){
            validationLabel.text = "The passwords are not matching"
            return
        }

        formType.value = textField.text
    }
}
