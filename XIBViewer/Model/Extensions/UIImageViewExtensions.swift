import UIKit

extension UIImageView{
    func circularImageFromURL(url: String){
        
        //circular border
        layer.masksToBounds = false
        layer.cornerRadius = Constant.ImageConstant.imageCornerRadius
        clipsToBounds = true
        
        //view image from URL using SDWebImage
        sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
    }
}
