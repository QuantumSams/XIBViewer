import UIKit

enum Constant {
    enum TextBoxConstant {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 2
        static let heightAnchor: CGFloat = 64
        static let backgroundColor: UIColor = .secondarySystemBackground
        static let borderColor: UIColor = .clear
    }

    enum ButtonConstant {
        static let cornerRadius: CGFloat = 12
        static let heightAnchor: CGFloat = 50
        static let borderWidth: CGFloat = 2
    }
    
    enum ImageConstant {
        static let imageHeight: CGFloat = 50
        static let imageWidth: CGFloat = 50
        static let imageCornerRadius = imageHeight / 2
        static let imageCGSize: CGSize = .init(width: imageWidth, height: imageHeight)
    }
    
    enum PopUpButtonConstant {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 2
        static let borderColor: UIColor = .tintColor
        static let backgroundColor: UIColor = .tintColor
        static let tintColor: UIColor = .tintColor
    }
    
    enum TabBarConstant {
        static let height: CGFloat = 40
        static let fontSize: CGFloat = 20
        static let backgroundColor: UIColor = .white
    }
}
