import UIKit

// source: https://stackoverflow.com/questions/25426780/how-to-have-stored-properties-in-swift-the-same-way-i-had-on-objective-c

// Enable storing stored properties inside an extensions
public final class ObjectAssociation<T: AnyObject> {
    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, self.policy) }
    }
}

public extension UIViewController {
    private static let association = ObjectAssociation<UIActivityIndicatorView>()

    internal var indicator: UIActivityIndicatorView {
        set { UIViewController.association[self] = newValue }
        get {
            if let indicator = UIViewController.association[self] {
                return indicator
            } else {
                UIViewController.association[self] = UIActivityIndicatorView.customIndicator(height: 100,
                                                                                             width: 100, center: self.view.center)
                return UIViewController.association[self]!
            }
        }
    }
    func startIndicatingActivity(isFullScreen:Bool = false) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            
            if isFullScreen {
                self.indicator = UIActivityIndicatorView.customFullScreenIndicator(
                    height: self.view.bounds.height,
                    width: self.view.bounds.width)
            }
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }

    func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension UIViewController {
    func pushToCustomVC(toVC: UIViewController) {
        navigationController?.pushViewController(toVC, animated: true)
    }

    func presentCustomVCWithNavigationController(toVC vc: UIViewController) {
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
}
