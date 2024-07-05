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
    
    var order: [String]  {
        switch self {
        case .login:
            return ["Email", "Password"]
        case .signup:
            return ["Name", "Email", "Password", "Confirm Password", "Role"]
        case .edit:
            return ["Name", "Email", "Role"]
        }
    }
    
    var getForm: [String:TableFormCellModel] {
        switch self{
        case .signup:
            return [
                "Name" :            TextFormCellModel(fieldType: .name,
                                                      fieldPlaceholder: "Name",
                                                      validationMethod: Validator.validateName),
                
                "Email":             TextFormCellModel(fieldType: .email,
                                                      fieldPlaceholder: "Email",
                                                      validationMethod: Validator.validateEmail),
                
                "Password":         TextFormCellModel(fieldType: .password,
                                                      fieldPlaceholder: "Password",
                                                      validationMethod: Validator.validatePassword),
                
                "Confirm Password": TextFormCellModel(fieldType: .confirmPassword,
                                                      fieldPlaceholder: "Confirm password",
                                                      validationMethod: nil),
                
                "Role":             PopupButtonFormCellModel(fieldType: .roleSelection,
                                                             label: "Role",
                                                             selection: RoleSingleton.accessSingleton.getAllRoleName())
            ]
        case .login:
            return [
                "Email":            TextFormCellModel(fieldType: .email,
                                                      fieldPlaceholder: "Email",
                                                      validationMethod: Validator.isDataEmpty),
                
                "Password":         TextFormCellModel(fieldType: .password,
                                                      fieldPlaceholder: "Password",
                                                      validationMethod: Validator.isDataEmpty)
            ]
        case .edit:
            return [
                "Email":            TextFormCellModel(fieldType: .email,
                                                      fieldPlaceholder: "Email",
                                                      validationMethod: Validator.validateEmail),
                
                "Name":             TextFormCellModel(fieldType: .name,
                                                      fieldPlaceholder: "Name",
                                                      validationMethod: Validator.validateName),
                
                "Role":             PopupButtonFormCellModel(fieldType: .roleSelection,
                                                             label: "Role",
                                                             selection: RoleSingleton.accessSingleton.getAllRoleName())
            ]
        }
    }
}
