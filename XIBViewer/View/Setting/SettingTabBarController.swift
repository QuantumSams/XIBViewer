//
//  SettingTabBarController.swift
//  XIBViewer
//
//  Created by Huy on 17/6/24.
//

import UIKit

final class SettingTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        }
}


extension SettingTabBarController{
    private func setupNav(){
        let accountVC = AccountVC()
        accountVC.tabBarItem.title = "Account"
        
        let userVC = UsersVC()
        userVC.tabBarItem.title = "Users"
        
        viewControllers = [accountVC, userVC]
    }
}
