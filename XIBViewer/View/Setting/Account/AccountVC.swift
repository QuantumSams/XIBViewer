import UIKit

final class AccountVC: UIViewController {

    //Property
    private var adminUser: UserModel
    
    //Outlet
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var firstNameField: UITextField!
    
    //Lifecycle
    
    init(user:UserModel){
        adminUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData(with: adminUser)
    }
    
    //Action - event processing
    @IBAction func editButtonTapped(_ sender: UIButton) {
        changeButtonOnTap(editButton, firstNameField.isEnabled)
        toggleTextFieldEnable(emailField)
        toggleTextFieldEnable(firstNameField)
        toggleTextFieldEnable(lastNameField)
    }
}

//Extenions - private methods
extension AccountVC: UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AccountVC{
    
    private func setupViews(){
        setupTextField(emailField)
        setupTextField(lastNameField)
        setupTextField(firstNameField)
        setupButton(editButton)
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
        //border button
        //state: not editable -> editable
        if(currentTextFieldEnableStatus == false){
            buttonToChange.layer.borderWidth = 2
            buttonToChange.setTitle("Finish editing", for: .normal) //need explaination
            buttonToChange.tintColor = .clear
            buttonToChange.setTitleColor(.systemPurple, for: .normal)
        }
        
        //filled button
        //status: editable->not editable
        else{
            buttonToChange.layer.borderWidth = 0
            buttonToChange.setTitle("Edit", for: .normal) //need explaination
            buttonToChange.tintColor = .systemPurple
            buttonToChange.setTitleColor(.white, for: .normal)
        }
    }
    
    private func loadData(with adminUser: UserModel){
        let seperatedName = adminUser.name.getFirstAndLastName()
        
        emailField.text = adminUser.email
        firstNameField.text = seperatedName[0]
        lastNameField.text = seperatedName[1]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
