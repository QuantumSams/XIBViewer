import UIKit

public extension UIActivityIndicatorView {
    static func customIndicator(height: CGFloat, width: CGFloat, center: CGPoint) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        indicator.center = center
        indicator.layer.cornerRadius = 12
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.backgroundColor = UIColor(red: 0/255,
                                            green: 0/255,
                                            blue: 0/255,
                                            alpha: 0.75)
        indicator.color = UIColor.white
        return indicator
    }

    static func customFullScreenIndicator(height: CGFloat, width: CGFloat) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.backgroundColor = UIColor.white
        indicator.color = UIColor.darkGray
        return indicator
    }
}
