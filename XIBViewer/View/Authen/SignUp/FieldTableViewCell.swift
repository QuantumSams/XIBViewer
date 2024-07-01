import UIKit

class FieldTableViewCell: UITableViewCell {
    
    static let id: String = "FieldTableViewCell"
    static var nib: UINib {
        UINib(nibName: "FieldTableViewCell", bundle: nil)
    }
    
    private var formType: FormItemModel?
    var delegate : setValueDelegate?
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func fieldDidEdit(_ sender: UITextField) {
        editCompleted()
    }
    @IBAction private func fieldEditing(_ sender: UITextField) {
        validationLabel.text = " "
    }
}

extension FieldTableViewCell{
   
    func setupCell(form: FormItemModel){
        formType = form
        
        self.textField.placeholder = formType?.fieldPlaceholder
        setupTextField(textField)
        validationLabel.text = " \n"
    }
}


extension FieldTableViewCell: UITextFieldDelegate{
    private func setupTextField(_ textField: UITextField) {
        textField.delegate = self // explaination needed
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.borderColor = UIColor.systemIndigo.cgColor
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}

extension FieldTableViewCell{
    private func editCompleted(){
        if delegate == nil{
            print("Delegate is nil")
            return
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
            validationLabel.text = checkValid
            return
        }
        
        delegate?.setData(for: formType.id, value: textField.text!)
        
    }
}
