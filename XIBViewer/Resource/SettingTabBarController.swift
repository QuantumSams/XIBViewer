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
        navigationItem.largeTitleDisplayMode = .always
        setupNav()
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


