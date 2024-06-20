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
    
    override func viewDidLayoutSubviews() {
        let height = navigationController?.navigationBar.frame.maxY
        tabBar.frame = CGRect(x: 0, y: height ?? 0, width: tabBar.frame.size.width, height: Constant.TabBarConstant.height)
        tabBar.isOpaque = false
        super.viewDidLayoutSubviews()
    }
}


extension SettingTabBarController{
    private func setupNav(){
        setupTitle(titleToSet: "Setting")
        setupTwoTabs(firstTab: AccountVC(), secondTab: UsersVC(), firstTabName: "Account", secondTabName: "Users")
    }
    private func setupTwoTabs(firstTab:UIViewController, secondTab:UIViewController, firstTabName:String? = nil, secondTabName:String? = nil)
    {
        if let firstTabName {
            firstTab.title = firstTabName
        }
        if let secondTabName{
            secondTab.title = secondTabName
        }
        setViewControllers([firstTab, secondTab], animated: true)

    }
    private func setupTitle(titleToSet:String){
        title = titleToSet
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
}


