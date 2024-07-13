import UIKit

extension UIImageView{
    func circularImageFromURL(url: URL){
        
        //circular border
        layer.masksToBounds = false
        layer.cornerRadius = Constant.ImageConstant.imageCornerRadius
        clipsToBounds = true
        
        //view image from URL using SDWebImage
        sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
    }
}
