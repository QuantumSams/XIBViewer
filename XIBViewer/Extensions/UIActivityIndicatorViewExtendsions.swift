import UIKit


extension UIActivityIndicatorView {
    public static func customIndicator(height: CGFloat, width: CGFloat) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.backgroundColor = UIColor.white
        return indicator
    }
}
