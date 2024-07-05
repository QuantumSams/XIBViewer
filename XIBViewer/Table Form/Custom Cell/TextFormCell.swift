import UIKit

final class TextFormCell: UITableViewCell {
    
    static var nib: UINib {
        UINib(nibName: "TextFormCell", bundle: nil)
    }
    static let id: String = "TextFormCell"
    private var formType:   TextFormCellModel?
    var passwordDelegate:   TableFormPasswordDelegate?
    

    @IBOutlet private weak var validationLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
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
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.borderColor = Constant.TextBoxConstant.borderColor.cgColor
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        textField.backgroundColor = Constant.TextBoxConstant.backgroundColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.size.height))
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
        self.textField.placeholder = formType?.fieldPlaceholder
        
        if let initialValue = formType?.value{
            textField.text = initialValue as? String
        }
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
        
        guard let formType else{
            fatalError("Form type is Nil - cell.Setup() haven't been called on parent's view")
        }
        
        guard let validationMethod = formType.validationMethod else{
            formType.value = textField.text
            return
        }
        
        
        if let checkValid = validationMethod(textField.text ?? " "){
            validationLabel.text = checkValid
            return
        }
        formType.value = textField.text
    }
    
    private func confirmPasswordEditComplete(){
        guard let formType else{
            fatalError("Form type is Nil - cell.Setup() haven't been called on parent's view")
        }
        guard let passwordDelegate else{
            fatalError("passwordDelegate is nil")
        }
        
        guard let passwordString = passwordDelegate.TableFormPasswordCollector(from: nil) else{
            return
        }
        
        if (passwordString != textField.text){
            validationLabel.text = "The passwords are not matching"
            return
        }

        formType.value = textField.text
    }
}
