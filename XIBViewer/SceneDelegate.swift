import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScence = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScence)
        self.window = window
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        window.rootViewController = UINavigationController(rootViewController: SignUpVC())
    }
}

extension SceneDelegate {
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
