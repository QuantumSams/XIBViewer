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
        checkAuthen(transition: false)
    }
}

extension SceneDelegate {
    public func checkAuthen(transition: Bool = true) {
        AuthService.refreshToken { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    TokenSingleton.getToken.setInitialToken(access: accessToken)
                    self?.swapRootVC(SettingTabBarVC(), transition: transition)
                    
                case .failure(let error):
                    print(error)
                    self?.swapRootVC(SignUpVC(), transition: transition)
                }
            }
        }
    }
    
    public func afterLogin(transition: Bool = true, token tokenData: SuccessLoginResponseDTO) {
        DispatchQueue.main.async {
            TokenSingleton.getToken.setInitialToken(access: tokenData.access, refresh: tokenData.refresh)
            self.swapRootVC(SettingTabBarVC(), transition: transition)
        }
    }
   
    func swapRootVC(_ swapToVC: UIViewController, transition: Bool) {
        guard let window = window else {
            return
        }
        DispatchQueue.main.async {
            let nextNavigation = UINavigationController(rootViewController: swapToVC)
            window.rootViewController = nextNavigation
            nextNavigation.modalPresentationStyle = .fullScreen
            
            if transition {
                UIView.transition(with: window, duration: 0.75, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        }
    }
}
