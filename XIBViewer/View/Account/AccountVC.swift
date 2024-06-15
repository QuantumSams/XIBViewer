import UIKit

final class AccountVC: UIViewController {

    //Property
    
    
    //Outlet
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var firstNameField: UITextField!
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //Action - event processing
    @IBAction func editButtonTapped(_ sender: UIButton) {
        toggleTextFieldEnable(emailField)
        toggleTextFieldEnable(firstNameField)
        toggleTextFieldEnable(lastNameField)
        
    }
}

//Extenions - private methods

extension AccountVC{
    
    private func setupViews(){
        displayNavigationTitle()
        setupTextField(emailField)
        setupTextField(lastNameField)
        setupTextField(firstNameField)
    }
    
    
    private func displayNavigationTitle(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Setting"
    }
    
    
    private func setupTextField(_ textField: UITextField){
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.isEnabled = false
        
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: 56)])
    }
    
    private func toggleTextFieldEnable(_ textField: UITextField){
        let currentTextFieldEnableStatus:Bool = textField.isEnabled
        textField.isEnabled = !currentTextFieldEnableStatus
    }
    
}
