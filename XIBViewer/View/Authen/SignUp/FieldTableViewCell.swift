//
//  FieldTableViewCell.swift
//  XIBViewer
//
//  Created by Huy on 30/6/24.
//

import UIKit

class FieldTableViewCell: UITableViewCell {
    
    static let id: String = "FieldTableViewCell"
    static var nib: UINib {
        UINib(nibName: "FieldTableViewCell", bundle: nil)
    }
    private var validationMethod: ((String) -> String?)?
    private var fieldData: String? = nil
    
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction private func fieldDidEdit(_ sender: UITextField) {
        guard let validationMethod = validationMethod else{
            fatalError("Validation method is nil")
        }
        
        
        
        if let checkValid = validationMethod(textField.text ?? " "){
            validationLabel.text = checkValid
        }
        
        fieldData = textField.text
    }
    @IBAction private func fieldEditing(_ sender: UITextField) {
        validationLabel.text = ""
    }
    
}

extension FieldTableViewCell{
    func setupCell(fieldPlaceholder: String, validationMethod: @escaping (String) -> String?){
        
        self.validationMethod = validationMethod
        setupTextField(textField)
        textField.placeholder = fieldPlaceholder
        validationLabel.text = " "
    }
    
    func getFieldData() -> String?{
        return fieldData
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
}
