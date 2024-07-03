import Foundation

class Validator{
    private static func validateString(for inputString: String, with regex: String?) -> Bool{
        let inputString = inputString.trimmingCharacters(in: .whitespacesAndNewlines)
        if (inputString == "") {return false}
        guard let regex = regex else{ return true }
        let regexFormula = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexFormula.evaluate(with: inputString)
    }
}

extension Validator{
    static func validateEmail(for email: String) -> String?{
        return validateString(for: email, with: RegexConstant.email) ? nil : "Email is not valid"
    }
  
    static func validatePassword(for password: String) -> String?{
        return validateString(for: password, with: RegexConstant.password) ? nil : "Password must be at least 8 characters long, with at least 1 number, 1 letter and 1 special character"
    }
    static func validateName(for name: String) -> String?{
        return validateString(for: name, with: nil) ? nil : "Name is not valid"
    }
    
    static func isDataEmpty(for anyString: String) -> String?{
        return !anyString.isEmpty ? nil : "Field can not empty"
    }
    
}
