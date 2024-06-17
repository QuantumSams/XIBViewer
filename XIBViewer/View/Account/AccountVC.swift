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
        changeButtonOnTap(editButton, emailField.isEnabled)
        toggleTextFieldEnable(emailField)
        toggleTextFieldEnable(firstNameField)
        toggleTextFieldEnable(lastNameField)
    }
}

//Extenions - private methods

extension AccountVC{
    
    private func setupViews(){
        self.navigationItem.hidesBackButton = true
        displayNavigationTitle()
        setupTextField(emailField)
        setupTextField(lastNameField)
        setupTextField(firstNameField)
        setupButton(editButton)
    }
    
    private func displayNavigationTitle(){
        let attatchment = NSTextAttachment()
        let imageString = NSMutableAttributedString(attachment: attatchment)
        let config = UIImage.SymbolConfiguration(scale: .large)
        attatchment.image = UIImage(systemName: "gearshape.fill", withConfiguration: config)
        let textString = NSAttributedString(string: "Setting")
        imageString.append(textString)
        
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.attributedText = imageString
        label.font =  UIFont.systemFont(ofSize: 28, weight: .bold)
        
        navigationItem.titleView = label
    }
    private func setupTextField(_ textField: UITextField){
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        textField.isEnabled = false
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
    }
    private func toggleTextFieldEnable(_ textField: UITextField){
        let currentTextFieldEnableStatus:Bool = textField.isEnabled
        textField.isEnabled = !currentTextFieldEnableStatus
    }
    private func setupButton(_ buttonToChange:UIButton){
        buttonToChange.layer.borderColor = UIColor.systemPurple.cgColor
        buttonToChange.layer.cornerRadius = 8
        changeButtonOnTap(buttonToChange, true)
        
    }
    private func changeButtonOnTap(_ buttonToChange:UIButton, _ currentTextFieldEnableStatus:Bool){
        //chang button appearance: lined -> filled
        //state: not editable -> editable
        if(currentTextFieldEnableStatus == false){
            buttonToChange.tintColor = UIColor.clear
            buttonToChange.layer.borderWidth = 2
        }
        else{
            buttonToChange.tintColor = UIColor.systemBlue
            buttonToChange.layer.borderWidth = 0

        }
        
    }
    
}
