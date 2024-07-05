import UIKit

class AlertManager{
    static func showAlert(on onVC:UIViewController,
                                title: String,
                                message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        
        DispatchQueue.main.async {
            onVC.present(alert, animated: true)
        }
    }
    
    
    private static func showButtonAlert(on onVC:UIViewController,
                                        title: String,
                                        message: String,
                                        buttonList: [UIAlertAction])
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttonList.forEach{button in
            alert.addAction(button)
        }
        
        
        DispatchQueue.main.async {
            onVC.present(alert, animated: true)
        }
    }
}

extension AlertManager{
    //Extends standard alert
    public static func showDeviceError(on onVC: UIViewController, message: String){
        self.showAlert(on: onVC, title: "Cannot send request", message: message)
    }
    
    public static func showServerErrorResponse(on onVC: UIViewController, message: String){
        self.showAlert(on: onVC, title: "Server error response", message: message)
    }
    
    public static func showGenericError(on onVC:UIViewController, message: String = "Plese try again"){
        self.showAlert(on: onVC, title: "Something went wrong", message: message)
    }
}

// for development only
extension AlertManager{
    public static func showDevelopmentError(on onVC: UIViewController, message: String, errorType:APIErrorTypes){
        let debugMessage = "Error type: \(errorType.localizedDescription)\n \(message)"
        self.showAlert(on: onVC, title: "Development error", message: debugMessage)
    }
}

extension AlertManager{
    //Extends alert with multiple button
    
    public static func logOutConfirmation(on onVC: UIViewController, completion: @escaping (Bool) -> Void){
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        let logoutButton = UIAlertAction(title: "Log out", style: .destructive) { _ in
            completion(true)
        }
        
        self.showButtonAlert(on: onVC,
                        title: "Log out",
                        message: "Do you actually want to log out?",
                        buttonList: [cancelButton, logoutButton]
        )
    }
    
}


//Form not complete response
extension AlertManager{
    public static func FormNotCompleted(on onVC:UIViewController, message: String = "Please fill all the requried fields"){
        self.showAlert(on: onVC, title: "Form not complete", message: message)
    }
    
}



