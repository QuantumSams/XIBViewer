import Foundation

class Validator{
    private static func validateString(for inputString: String, with regex: String?) -> Bool{
        
        guard let regex = regex else{ return true }
        let regexFormula = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexFormula.evaluate(with: inputString)
    }
}

extension Validator{
    static func validateEmail(for email: String?) -> String?{
        guard let 
                email = email,
                email.isEmpty == false
        else{
            return "Email cannot be empty"
        }
        return validateString(for: email, with: RegexConstant.email) ? nil : "Email is not valid"
    }
  
    static func validatePassword(for password: String?) -> String?{
        guard let
                password = password,
                password.isEmpty == false
        else{
            return "Password cannot be empty"
        }
        
        return validateString(for: password, with: RegexConstant.password) ? nil : "Password must be at least 8 characters long, with at least 1 number, 1 letter and 1 special character"
    }
    static func validateName(for name: String?) -> String?{
        guard let
                name = name,
                name.isEmpty == false
               else{
                   return "Name cannot be empty"
               }
        
        
        return validateString(for: name, with: nil) ? nil : "Name is not valid"
    }
    
    static func comparePassword(password: String?, confirmPassword: String?) -> String?{

        guard password != "" else {
            
            return nil
        }
        
        if confirmPassword != nil &&
            confirmPassword == password &&
            confirmPassword != ""{
            return nil
        }
        
        return "Password are not matching"
    }
    
    static func isDataEmpty(for anyString: String?) -> String?{
        guard anyString != "" else{
            return "Field can not empty"
        }
        return nil
    }
    
}
