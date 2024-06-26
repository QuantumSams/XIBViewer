
import UIKit

final class SettingTabBarController: UITabBarController {
    
    var adminUser:UserModel
    
    init(adminUser: UserModel) {
        self.adminUser = adminUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tabBarItemFontAttribute: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(
            ofSize: Constant.TabBarConstant.fontSize,
            weight: UIFont.Weight.bold
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarPosition()
    }
}

extension SettingTabBarController: UITabBarControllerDelegate{
    
    private func setupNav(){
        initialSetup()
        
        let firstTab = modifyVC(viewController: AccountVC(user: adminUser), title: "Account", tag: 0)
        let secondTab = modifyVC(viewController: UsersVC(), title: "Users", tag: 1)
        
        setViewControllers([firstTab, secondTab], animated: true)
        tabBar.tintColor = .systemPurple
        selectedIndex = 0
    }
    
    private func modifyVC(viewController: UIViewController, title: String, tag:Int) -> UIViewController{
        let returningVC = viewController
        returningVC.tabBarItem = UITabBarItem(title: title, image: nil, tag: tag)
        returningVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        return returningVC
    }
    
    private func initialSetup(){
        self.delegate = self
        title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        UITabBarItem.appearance().setTitleTextAttributes(tabBarItemFontAttribute, for: .normal)
    }
    
    private func setupTabBarPosition(){
        let height = navigationController?.navigationBar.frame.maxY
        tabBar.frame = CGRect(x: 0, y: height ?? 0, width: tabBar.frame.size.width, height: Constant.TabBarConstant.height)
        tabBar.isOpaque = false
        tabBar.barTintColor = Constant.TabBarConstant.backgroundColor
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch(tabBar.selectedItem?.tag){
        case 0: tabBar.tintColor = UIColor.systemPurple
            break
        case 1: tabBar.tintColor = UIColor.systemBlue
            break
        default:
            break
            
        }
    }
}
