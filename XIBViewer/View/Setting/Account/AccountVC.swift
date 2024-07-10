import UIKit

final class AccountVC: UIViewController {

<<<<<<< HEAD
    //MARK: - Property
    private var adminUser: UserModel? = nil
    private var isLoading: Bool = false {
        didSet{
            editButton.setNeedsUpdateConfiguration()
        }
    }
||||||| 803fb5e
    //Property
    private var adminUser: UserModel
=======
    //Property
    private var adminUser: UserModel? = nil
>>>>>>> feat_Auth_API
    
    //MARK: - OUTLET
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var editButton: UIButton!
<<<<<<< HEAD
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var roleField: UITextField!
    @IBOutlet private weak var logoutButton: UIButton!
    //MARK: - LIFECYCLE
||||||| 803fb5e
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var firstNameField: UITextField!
    
    @IBOutlet weak var logoutButton: UIButton!
    //Lifecycle
    
    init(user:UserModel){
        adminUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
=======
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
>>>>>>> feat_Auth_API
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
<<<<<<< HEAD
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(adminUser == nil){
            adminUserAPIRequest()
        }
||||||| 803fb5e
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData(with: adminUser)
=======
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
>>>>>>> feat_Auth_API
    }
    
    //MARK: - EVENT CATCHING
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let vc = EditVC(existingData: adminUser)
        vc.delegate = self
        
        navigateToCustomController(to: vc)
        
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
//MARK: - ADDITIONAL METHODS


// SetupView
extension AccountVC{
    
    private func setupViews(){
        setupTextField(emailField)
        setupTextField(nameField)
        setupTextField(roleField)
        
        logoutButton.setupButton(
            cornerRadius: Constant.ButtonConstant.cornerRadius,
            borderWidth: 0,
            buttonHeight: Constant.ButtonConstant.heightAnchor,
            maskToBound: true
        )
        
        logoutButton.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            button.isEnabled = !self.isLoading
            button.configuration = config
        }
    }
    
    private func setupTextField(_ textField: UITextField){
        textField.layer.borderWidth = Constant.TextBoxConstant.borderWidth
        textField.layer.borderColor = Constant.TextBoxConstant.borderColor.cgColor
        textField.layer.cornerRadius = Constant.TextBoxConstant.cornerRadius
        textField.backgroundColor = Constant.TextBoxConstant.backgroundColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.size.height))
        NSLayoutConstraint.activate([textField.heightAnchor.constraint(equalToConstant: Constant.TextBoxConstant.heightAnchor)])
        textField.isEnabled = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
<<<<<<< HEAD
}

//Navigating routes
extension AccountVC{
||||||| 803fb5e
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
    
=======
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
        
        DispatchQueue.main.async {
            let seperatedName = adminUser.name.getFirstAndLastName()
            self.emailField.text = adminUser.email
            self.firstNameField.text = seperatedName[0]
            self.lastNameField.text = seperatedName[1]
        }
    }
    
>>>>>>> feat_Auth_API
    private func logoutAccount(){
        TokenSingleton.getToken.removeToken()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.checkAuthen()
    }
    
    private func navigateToCustomController(to vc: UIViewController){
        self.present(UINavigationController(rootViewController: vc), animated: true)
            
    }
}

// API Calling
extension AccountVC{
    private func parseDataToFields(with adminUser: UserModel){
        DispatchQueue.main.async {
            self.emailField.text = adminUser.email
            self.nameField.text = adminUser.name
            self.roleField.text = adminUser.role.name.capitalized
        }
    }
    
    private func adminUserAPIRequest(){
        self.startIndicatingActivity()
        AccountService.getAccount { [weak self] result in
            switch result{
            case .success(let adminUser):
                self?.adminUser = adminUser
                self?.parseDataToFields(with: adminUser)
                self?.stopIndicatingActivity()
            case .failure(_):
                AlertManager.showDeviceError(on: self!, message: "Something went wrong, please login again")
                self?.logoutAccount()
            }
        }
    }
}


//MARK: - DELEGATE
extension AccountVC: EditRefreshDataDelegate{
    func doneEditing(send newUserData: UserModel) {
        parseDataToFields(with: newUserData)
    }
}
