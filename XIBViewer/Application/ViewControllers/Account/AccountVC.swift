import UIKit

class AccountVC: UIViewController {
//    private var adminUser: UserModel?
    private var isLoading: Bool = false
    private let viewModel: AccountVM

    // MARK: - OUTLET

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var roleField: UITextField!
    @IBOutlet private var logoutButton: UIButton!

    // MARK: - LIFECYCLE

    init() {
        self.viewModel = AccountVM()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindingVM()
    }

    // MARK: - EVENT CATCHING

    @IBAction func editButtonTapped(_ sender: UIButton) {
        guard let user = viewModel.adminUser else {
            return
        }

        let vc = EditVC(existingData: user, delegate: self)
        presentCustomVCWithNavigationController(toVC: vc)
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        AlertManager.logOutConfirmation(on: self) { logoutConfirm in
            if logoutConfirm == true {
                self.logoutButton.configuration?.showsActivityIndicator = true
                self.logoutButton.isEnabled = false
                self.editButton.isEnabled = false
                self.viewModel.revokeAuthen()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.swapRootVC(SignUpVC(), transition: true)
            }
        }
    }
}

// MARK: - ADDITIONAL METHODS

// SetupView
extension AccountVC {
    private func setupViews() {
        setupTextField(emailField)
        setupTextField(nameField)
        setupTextField(roleField)

        logoutButton.setupButton(
            cornerRadius: Constant.ButtonConstant.cornerRadius,
            borderWidth: 0,
            buttonHeight: Constant.ButtonConstant.heightAnchor,
            maskToBound: true
        )

        logoutButton.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            button.isEnabled = !self.isLoading
            button.configuration = config
        }
    }

    private func setupTextField(_ textField: UITextField) {
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
        view.endEditing(true)
    }
}

// API Calling
extension AccountVC {
    private func parseDataToFields(with adminUser: AccountModel?) {
        guard let adminUser = adminUser else { return }
        DispatchQueue.main.async {
            self.emailField.text = adminUser.email
            self.nameField.text = adminUser.name
            self.roleField.text = adminUser.role.name.capitalized
        }
    }

    private func bindingVM() {
        startIndicatingActivity()
        viewModel.fetchAdminData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.parseDataToFields(with: self.viewModel.adminUser)
                self.stopIndicatingActivity()
            case .failure(let error):
                guard let error = error as? APIErrorTypes else {
                    viewModel.revokeAuthen()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.swapRootVC(SignUpVC(), transition: true)
                    return
                }
                switch error {
                case .deviceError(let err):
                    AlertManager.retryAPICall(on: self, message: err) {
                        self.bindingVM()
                    }
                default:
                    AlertManager.alertOnAPIError(with: error, on: self)
                    viewModel.revokeAuthen()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.swapRootVC(SignUpVC(), transition: true)
                }
            }
        }
    }
}

// MARK: - DELEGATE

extension AccountVC: EditVCDelegate {
    func doneEditing(send newUserData: AccountModel) {
        parseDataToFields(with: newUserData)
    }
}
