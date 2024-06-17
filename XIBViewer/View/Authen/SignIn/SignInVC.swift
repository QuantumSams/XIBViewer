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

extension SignInVC: UITextFieldDelegate{
    private func setupViews(){
        setupTextField(usernameField)
        setupTextField(passwordField)
        setupButton(loginButton)
    }
    
    private func setupTextField(_ customTextField:UITextField){
        customTextField.delegate = self
        customTextField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        customTextField.layer.borderColor = UIColor.systemBlue.cgColor
        customTextField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        customTextField.layer.masksToBounds = true
        customTextField.borderStyle = .roundedRect
        
        NSLayoutConstraint.activate([customTextField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
    }
    
    private func setupButton(_ customButton: UIButton){
        customButton.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        customButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([customButton.heightAnchor.constraint(equalToConstant: Constant.ButtonConstant.heightAnchor)])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

