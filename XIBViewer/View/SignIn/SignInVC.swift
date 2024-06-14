import UIKit

final class SignInVC: UIViewController {

    //Outlet
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //Action - event processing
   
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button clicked")
    }
}

//Private method

extension SignInVC{
    private func setupViews(){
        setupTextField(usernameField)
        setupTextField(passwordField)
        setupButton(loginButton)
    }
    
    private func setupTextField(_ customTextField:UITextField){
        customTextField.layer.cornerRadius = 20
        customTextField.layer.borderColor = UIColor.systemBlue.cgColor
        customTextField.layer.borderWidth = 1
        customTextField.layer.masksToBounds = true
        customTextField.borderStyle = .roundedRect
        
        NSLayoutConstraint.activate([customTextField.heightAnchor.constraint(equalToConstant: 64)])
    }
    
    private func setupButton(_ customButton: UIButton){
        customButton.layer.cornerRadius = 16
        customButton.layer.masksToBounds = true
    }
}

