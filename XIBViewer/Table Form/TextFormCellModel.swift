import UIKit


final class TextFormCellModel: TableFormCellModel{
    
    init(fieldType: TableFieldTypes ,fieldPlaceholder: String? = nil, validationMethod: @escaping (String) -> String?) {
        self.fieldPlaceholder = fieldPlaceholder
        self.validationMethod = validationMethod
        super.init(fieldType: fieldType)
    }
    var fieldPlaceholder: String?
    let validationMethod: (String) -> String?
    
    var keyboardType: UIKeyboardType {
        switch fieldType{
            
        case .name:
                .default
        case .email:
                .emailAddress
        case .password:
                .default
        case .confirmPassword:
                .default
        default:
                .default
        }
    }
    
    var secureEntry: Bool{
        switch fieldType{
        case .password, .confirmPassword: true

        default: false
        }
    }
}
