
    //MARK: - OUTLET
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var roleField: UITextField!
    @IBOutlet private weak var logoutButton: UIButton!
    //MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(adminUser == nil){
            adminUserAPIRequest()
        }
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
}

//Navigating routes
extension AccountVC{

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
