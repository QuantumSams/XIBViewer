//
//  UsersTableCell.swift
//  XIBViewer
//
//  Created by Huy on 18/6/24.
//

import UIKit
import SDWebImage

class UsersTableCell: UITableViewCell {
    
    @IBOutlet private weak var cellName: UILabel!
    @IBOutlet private weak var cellEmail: UILabel!
    @IBOutlet private weak var imageCell: UIImageView!
    static private let id = "UsersTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension UIImageView{
    func circularImageFromURL(url: String){
        
        //circular
        layer.masksToBounds = false
        layer.cornerRadius = Constant.ImageConstant.imageCornerRadius
        clipsToBounds = true
        
        //view image from URL
        sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
    }
}


extension UsersTableCell{
    static func getNib() -> UINib{
        return UINib(nibName: "UsersTableCell", bundle: nil)
    }
    
    static func getID() -> String{
        id
    }
    func setData(user:UserModel){
        cellName.text = user.name
        cellEmail.text = user.email
        
        if let validImageURL = user.imageURL{
            imageCell.circularImageFromURL(url: validImageURL)
        }
        else{
            imageCell.image = UIImage(systemName: "person.crop.circle.fill")
        }
    }
}
