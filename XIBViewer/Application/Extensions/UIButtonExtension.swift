import UIKit

extension UIButton {
    func setupButton(title: String? = nil,
                     titleColor: UIColor? = nil,
                     tintColor: UIColor? = nil,
                     borderColor: UIColor? = nil,
                     cornerRadius: CGFloat = Constant.ButtonConstant.cornerRadius,
                     borderWidth: CGFloat = Constant.ButtonConstant.borderWidth,
                     buttonHeight: CGFloat = Constant.ButtonConstant.heightAnchor,
                     maskToBound: Bool = true)
    {
        self.layer.masksToBounds = true
        
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        
        if let titleColor = titleColor {
            self.setTitleColor(titleColor, for: .normal)
        }
        
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        NSLayoutConstraint.activate([self.heightAnchor.constraint(equalToConstant: buttonHeight)])
    }
}
