import UIKit

enum actionSheetEnum {
    case edit
    case delete
    case cancel
}

class AlertManager {
    static func showAlert(on onVC: UIViewController,
                          title: String,
                          message: String,
                          style: UIAlertController.Style = .alert)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        DispatchQueue.main.async {
            onVC.present(alert, animated: true)
        }
    }
    
    private static func showButtonAlert(on onVC: UIViewController,
                                        title: String,
                                        message: String,
                                        buttonList: [UIAlertAction],
                                        style: UIAlertController.Style = .alert)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for button in buttonList {
            alert.addAction(button)
        }
        
        DispatchQueue.main.async {
            onVC.present(alert, animated: true)
        }
    }
}

extension AlertManager {
    // Extends standard alert
    private static func showDeviceError(on onVC: UIViewController, message: String) {
        self.showAlert(on: onVC, title: "Cannot send request", message: message)
    }
    
    private static func showServerErrorResponse(on onVC: UIViewController, message: String) {
        self.showAlert(on: onVC, title: "Server error response", message: message)
    }
    
    public static func showGenericError(on onVC: UIViewController, message: String = "Plese try again") {
        self.showAlert(on: onVC, title: "Something went wrong", message: message)
    }
}

// for development only
extension AlertManager {
    public static func showDevelopmentError(on onVC: UIViewController, message: String, errorType: APIErrorTypes) {
        let debugMessage = "Error type: \(errorType.localizedDescription)\n \(message)"
        self.showAlert(on: onVC, title: "Development error", message: debugMessage)
    }
}

extension AlertManager {
    // Extends alert with multiple button
    
    public static func logOutConfirmation(on onVC: UIViewController, completion: @escaping (Bool) -> Void) {
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        let logoutButton = UIAlertAction(title: "Log out", style: .destructive) { _ in
            completion(true)
        }
        
        self.showButtonAlert(on: onVC,
                             title: "Log out",
                             message: "Do you actually want to log out?",
                             buttonList: [cancelButton, logoutButton])
    }

    public static func deleteUserConfirm(on onVC: UIViewController, completion: @escaping (Bool) -> Void) {
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        let logoutButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }
        
        self.showButtonAlert(on: onVC,
                             title: "Confirm deletion",
                             message: "Do you actually want to delete this person?",
                             buttonList: [cancelButton, logoutButton])
    }
}

// Form not complete response
extension AlertManager {
    public static func FormNotCompleted(on onVC: UIViewController, message: String = "Please fill all the requried fields") {
        self.showAlert(on: onVC, title: "Form not complete", message: message)
    }
}

// Action sheet for selection

extension AlertManager {
    public static func userMenu(on vc: UIViewController, completion: @escaping (actionSheetEnum) -> Void) {
        let editActionButton = UIAlertAction(title: "Edit", style: .default) { _ in
            completion(.edit)
        }
        
        let deleteActionButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(.delete)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
                
        self.showButtonAlert(on: vc,
                             title: "Account action",
                             message: "Select an action for this user.",
                             buttonList: [editActionButton, deleteActionButton, cancelActionButton],
                             style: .actionSheet)
    }
}

extension AlertManager {
    public static func alertOnAPIError(with error: APIErrorTypes, on vc: UIViewController) {
        switch error {
        case .deviceError(let string):
            self.showDeviceError(on: vc, message: string)
        case .serverError(let string):
            self.showServerErrorResponse(on: vc, message: string)
        case .decodingError(let string):
            self.showDevelopmentError(on: vc, message: string, errorType: .decodingError())
        case .unknownError(let string):
            self.showDevelopmentError(on: vc, message: string, errorType: .unknownError())
        case .dataIsMissing:
            self.FormNotCompleted(on: vc)
        }
    }
}
