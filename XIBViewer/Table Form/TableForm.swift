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
    case edit
    
    
    var getForm: [TableFormCellModel] {
        switch self{
        case .signup:
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
                                  validationMethod: nil),
                
                PopupButtonFormCellModel(fieldType: .roleSelection,
                                        label: "Role",
                                        selection: RoleSingleton.accessSingleton.getAllRoleName())]
        case .login:
            return [
                TextFormCellModel(fieldType: .email, 
                                  fieldPlaceholder: "Email",
                                  validationMethod: Validator.isDataEmpty),
                
                TextFormCellModel(fieldType: .password,
                                  fieldPlaceholder: "Password",
                                  validationMethod: Validator.isDataEmpty)
            ]
        case .edit:
            return [
                TextFormCellModel(fieldType: .email,
                                  fieldPlaceholder: "Email",
                                  validationMethod: Validator.validateEmail),
                
                TextFormCellModel(fieldType: .name,
                                  fieldPlaceholder: "Name",
                                  validationMethod: Validator.validateName),
                
                PopupButtonFormCellModel(fieldType: .roleSelection,
                                        label: "Role",
                                        selection: RoleSingleton.accessSingleton.getAllRoleName())
            ]
        }
    }
}
