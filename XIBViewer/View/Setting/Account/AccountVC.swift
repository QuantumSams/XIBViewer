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
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var roleField: UITextField!
    @IBOutlet private weak var logoutButton: UIButton!
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
        navigateToCustomController(
            to:  UINavigationController(rootViewController: EditVC())
        )
        
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
   
   
    private func loadData(with adminUser: UserModel){
        
        DispatchQueue.main.async {
            self.emailField.text = adminUser.email
            self.nameField.text = adminUser.name
            self.roleField.text = adminUser.role.name.capitalized
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

extension AccountVC{
    private func navigateToCustomController(to vc: UIViewController){
        self.present(vc, animated: true)
    }
}
