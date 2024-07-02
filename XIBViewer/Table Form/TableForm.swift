import Foundation

enum TableFieldTypes: String{
    case name = "name"
    case email = "email"
    case password = "password"
    case confirmPassword = "confirmPassword"
    case roleSelection = "roleSelection"
    case custom = "custom"
}


enum TableForm{
    case login
    case signup
    
    var getForm: [TableFormCellModel] {
        switch self{
        case .login:
            return [
                TextFormCellModel(fieldType: .name, 
                                  fieldPlaceholder: "Name",
                                  validationMethod: Validator.validateName),
                
                TextFormCellModel(fieldType: .email,
                                  fieldPlaceholder: "Email",
                                  validationMethod:
                                    Validator.validateEmail),
                
                TextFormCellModel(fieldType: .password, 
                                  fieldPlaceholder: "Password",
                                  validationMethod: Validator.validatePassword),
                
                TextFormCellModel(fieldType: .confirmPassword, 
                                  fieldPlaceholder: "Confirm password",
                                  validationMethod: Validator.validatePassword),
                
                PopupButtonFormCellModel(fieldType: .roleSelection,
                                        label: "Role",
                                        selection: RoleSingleton.accessSingleton.getAllValue())]
        case .signup:
            return [
                TextFormCellModel(fieldType: .email,
                                  validationMethod: Validator.validateName),
                
                TextFormCellModel(fieldType: .password,
                                  validationMethod: Validator.validatePassword)
            ]
        }
    }
}
