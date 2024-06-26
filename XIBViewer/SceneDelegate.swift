//
//  SceneDelegate.swift
//  XIBViewer
//
//  Created by Huy on 28/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScence = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScence)
        self.window = window
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        checkAuthen()
    }
}

extension SceneDelegate{
    
    public func checkAuthen(){
        AccountService.getAccount(completion: {[weak self] result in
            DispatchQueue.main.async{
                switch result{
                case .success(let adminUser):
                    self?.swapRootVC(SettingTabBarController(adminUser: adminUser))
                case .failure(_):
                    self?.swapRootVC(SignUpVC())
                    }
                }
            }
        )
    }
    
    func swapRootVC(_ swapToVC: UIViewController){
        
        guard let window = window else{
            return
        }
        DispatchQueue.main.async {
            let nextNavigation = UINavigationController(rootViewController: swapToVC)
            window.rootViewController = nextNavigation
            nextNavigation.modalPresentationStyle = .fullScreen
        }
    }
}
