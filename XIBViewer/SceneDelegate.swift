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
        getRoles()
//        checkAuthen(transition: false)
    }
}

extension SceneDelegate{
    
    private func getRoles(){
        RoleService.getRole { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let roleData):
                    RoleSingleton.accessSingleton.setRole(newRole: roleData.results)
                    self.checkAuthen(transition: false)
                case .failure(let string):
                    //TODO: HANDLE CASE
                    print(string)
                }
            }
            return
        }
    }
    
    public func checkAuthen(transition: Bool = true){
        AccountService.getAccount(completion: {[weak self] result in
            DispatchQueue.main.async{
                switch result{
                case .success(let adminUser):
                    self?.swapRootVC(SettingTabBarController(adminUser: adminUser), transition: transition)
                case .failure(_):
                    self?.swapRootVC(SignUpVC(), transition: transition)
                    }
                }
            }
        )
    }
    
    func swapRootVC(_ swapToVC: UIViewController, transition: Bool){
        
        guard let window = window else{
            return
        }
        DispatchQueue.main.async {
            let nextNavigation = UINavigationController(rootViewController: swapToVC)
            window.rootViewController = nextNavigation
            nextNavigation.modalPresentationStyle = .fullScreen
            
            if(transition){
                UIView.transition(with: window, duration: 0.75, options: .transitionFlipFromRight ,animations: nil, completion: nil)
            }
            
        }
    }
}
