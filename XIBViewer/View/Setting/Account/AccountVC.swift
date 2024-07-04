import UIKit

final class AccountVC: UIViewController {

    //Property
    private var adminUser: UserModel? = nil
    private var isLoading: Bool = false {
        didSet{
            editButton.setNeedsUpdateConfiguration()
        }
    }
    
    //Outlet
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var firstNameField: UITextField!
    
    @IBOutlet weak var logoutButton: UIButton!
    //Lifecycle
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AccountService.getAccount { [weak self] result in
            switch result{
            case .success(let adminUser):
                self?.adminUser = adminUser
                self?.loadData(with: adminUser)
            case .failure(_):
                AlertManager.showDeviceError(on: self!, message: "Something went wrong, please login again")
                self?.logoutAccount()
            }
        }
    }
    
    //Action - event processing
    @IBAction func editButtonTapped(_ sender: UIButton) {
        changeButtonOnTap(editButton, firstNameField.isEnabled)
        toggleAvailability(for: emailField, currentStatus: emailField.isEnabled)
        toggleAvailability(for: firstNameField, currentStatus: firstNameField.isEnabled)
        toggleAvailability(for: lastNameField, currentStatus: lastNameField.isEnabled)
        toggleAvailability(for: logoutButton, currentStatus: logoutButton.isEnabled)
        
        
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        AlertManager.logOutConfirmation(on: self) { logoutConfirm in
            if(logoutConfirm == true){
                self.logoutButton.configuration?.showsActivityIndicator = true
                self.logoutButton.isEnabled = false
                self.editButton.isEnabled = false
                self.logoutAccount()
            }
        }
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
        
        editButton.setupButton(
            borderColor: UIColor.systemPurple,
            cornerRadius: 4,
            buttonHeight: 40,
            maskToBound: false
        )
        changeButtonOnTap(editButton, true)
        logoutButton.setupButton(
            tintColor: UIColor.systemRed,
            borderWidth: 0
        )
        
        logoutButton.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            button.isEnabled = !self.isLoading
            button.configuration = config
        }
    }
    
    private func setupTextField(_ textField: UITextField){
        textField.layer.masksToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        textField.isEnabled = false
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
    }
    private func toggleAvailability(for control: UIControl, currentStatus: Bool){
        control.isEnabled = !currentStatus
    }
    private func setupButton(_ buttonToChange: UIButton, defaultBorderColor: UIColor? = nil, defaultTintColor: UIColor? = nil){
        
        if let defaultBorderColor = defaultBorderColor{
            buttonToChange.layer.borderColor = defaultBorderColor.cgColor
        }
        
        if let defaultTintColor = defaultTintColor{
            buttonToChange.tintColor = defaultTintColor
        }
        
        buttonToChange.layer.cornerRadius = Constant.ButtonConstant.cornerRadius
        
    }
    
    private func changeButtonOnTap(_ buttonToChange:UIButton, _ currentTextFieldEnableStatus:Bool){
        //border button
        //state: not editable -> editable
        if(currentTextFieldEnableStatus == false){
           
            buttonToChange.layer.borderWidth = Constant.ButtonConstant.borderWidth
            buttonToChange.setTitle("Finish editing", for: .normal) //need explaination
            buttonToChange.tintColor = .clear
            buttonToChange.setTitleColor(.tintColor, for: .normal)
        }
        
        //filled button
        //status: editable->not editable
        else{
            buttonToChange.layer.borderWidth = 0
            buttonToChange.setTitle("Edit", for: .normal) //need explaination
            buttonToChange.tintColor = .tintColor
            buttonToChange.setTitleColor(.white, for: .normal)
        }
    }
    
    private func loadData(with adminUser: UserModel){
        
        DispatchQueue.main.async {
            let seperatedName = adminUser.name.getFirstAndLastName()
            self.emailField.text = adminUser.email
            self.firstNameField.text = seperatedName[0]
            self.lastNameField.text = seperatedName[1]
        }
    }
    
    private func logoutAccount(){
        TokenSingleton.getToken.removeToken()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.checkAuthen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
