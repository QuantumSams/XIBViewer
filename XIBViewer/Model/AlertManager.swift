import UIKit

class AlertManager{
    private static func showAlert(on onVC:UIViewController,
                                title: String,
                                message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        
        DispatchQueue.main.async {
            onVC.present(alert, animated: true)
        }
    }
}

extension AlertManager{
    public static func showNoWifiConnection(on onVC:UIViewController){
        self.showAlert(on: onVC, title: "No internet", message: "AAAAAAAA")
    }
}



