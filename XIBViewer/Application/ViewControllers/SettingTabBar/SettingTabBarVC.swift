import UIKit

final class SettingTabBarVC: UITabBarController {
    // MARK: - VARIABLES

    // MARK: - OUTLETS

    // MARK: - LIFECYCLE

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarPosition()
    }
}

// MARK: - DELEGATE/DATASOURCE CONFORM

// UITabBarControllerDelegate
extension SettingTabBarVC: UITabBarControllerDelegate {
    private func modifyVC(viewController: UIViewController, title: String, tag: Int) -> UIViewController {
        let returningVC = viewController
        returningVC.tabBarItem = UITabBarItem(title: title, image: nil, tag: tag)
        returningVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        return returningVC
    }
}

// MARK: - ADDITIONAL METHODS

// Setup Views
extension SettingTabBarVC {
    private func setupNav() {
        initialSetup()
        
        let firstTab = modifyVC(viewController: AccountVC(), title: "Account", tag: 0)
        let secondTab = modifyVC(viewController: UsersVC(), title: "Users", tag: 1)
        
        setViewControllers([firstTab, secondTab], animated: true)
        selectedIndex = 0
    }
    
    private func initialSetup() {
        let tabBarItemFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: Constant.TabBarConstant.fontSize,
                weight: UIFont.Weight.bold
            ),
        ]
        delegate = self
        title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        UITabBarItem.appearance().setTitleTextAttributes(tabBarItemFontAttribute, for: .normal)
    }

    private func setupTabBarPosition() {
        let height = navigationController?.navigationBar.frame.maxY
        tabBar.frame = CGRect(x: 0, y: height ?? 0, width: tabBar.frame.size.width, height: Constant.TabBarConstant.height)
        tabBar.isOpaque = false
        tabBar.barTintColor = Constant.TabBarConstant.backgroundColor
    }
}
