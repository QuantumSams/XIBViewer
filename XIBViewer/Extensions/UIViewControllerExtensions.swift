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
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}


extension UIViewController {
    private static let association = ObjectAssociation<UIActivityIndicatorView>()

    var indicator: UIActivityIndicatorView {
        set { UIViewController.association[self] = newValue }
        get {
            if let indicator = UIViewController.association[self] {
                return indicator
            } else {
                UIViewController.association[self] = UIActivityIndicatorView.customIndicator(height: self.view.bounds.height,
                                                                                             width: self.view.bounds.width)
                return UIViewController.association[self]!
            }
        }
    }
    
    public func startIndicatingActivity() {
        DispatchQueue.main.async {
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
    }

    public func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }
}
