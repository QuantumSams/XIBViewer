import UIKit
struct Constant{
    struct TextBoxConstant{
        static let cornerRadius:CGFloat = 12
        static let borderWidth: CGFloat = 2
        static let heightAnchor:CGFloat = 64
        static let backgroundColor: UIColor = .secondarySystemBackground
        static let borderColor: UIColor = .clear
    }
    struct ButtonConstant{
        static let cornerRadius:CGFloat = 12
        static let heightAnchor:CGFloat = 50
        static let borderWidth:CGFloat = 2
    }
    
    struct ImageConstant{
        static let imageHeight:CGFloat = 50
        static let imageWidth:CGFloat = 50
        static let imageCornerRadius = imageHeight / 2
        static let imageCGSize: CGSize = CGSize(width: imageWidth, height: imageHeight)
    }
    
    struct PopUpButtonConstant{
        static let cornerRadius:CGFloat = 12
        static let borderWidth:CGFloat = 2
        static let borderColor:UIColor = UIColor.tintColor
        static let backgroundColor:UIColor = UIColor.tintColor
        static let tintColor:UIColor = UIColor.tintColor
    }
    
    struct TabBarConstant{
        static let height: CGFloat = 40
        static let fontSize: CGFloat = 20
        static let backgroundColor: UIColor = UIColor.white
    }
}
