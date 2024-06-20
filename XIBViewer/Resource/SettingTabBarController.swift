
import UIKit

final class SettingTabBarController: UITabBarController {
    
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
        self.delegate = self
        title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTwoTabs(firstTab: AccountVC(), 
                     secondTab: UsersVC(),
                     firstTabName: "Account",
                     secondTabName: "Users")
        
        tabBar.tintColor = .systemPurple
        selectedIndex = 0
    }
    
    
    private func setupTwoTabs(firstTab:UIViewController, secondTab:UIViewController, firstTabName:String, secondTabName:String)
    {
        firstTab.tabBarItem = UITabBarItem(title: firstTabName, image: nil, tag: 0)
        secondTab.tabBarItem = UITabBarItem(title: secondTabName, image: nil, tag: 1)
        setupTabBarItemsVisual([firstTab, secondTab])
        setViewControllers([firstTab, secondTab], animated: true)
    }
    
    private func setupTabBarItemsVisual(_ listOfView:[UIViewController]){
        for view in listOfView{
            // centered text
            view.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        }
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
