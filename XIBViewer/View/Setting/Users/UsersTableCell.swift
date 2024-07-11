import UIKit
import SDWebImage

class UsersTableCell: UITableViewCell {
    

    @IBOutlet private weak var moreInfoButton: UIButton!
    @IBOutlet private weak var cellName: UILabel!
    @IBOutlet private weak var cellEmail: UILabel!
    @IBOutlet private weak var imageCell: UIImageView!
    
    static private let id = "UsersTableCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setupButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UsersTableCell{
    static func getNib() -> UINib{
        UINib(nibName: "UsersTableCell", bundle: nil)
    }
    
    static func getID() -> String{
        id
    }
    
    func setData(user:UserModel){
        cellName.text = user.name
        cellEmail.text = user.email
//
        //load image from URL
        //imageCell.circularImageFromURL(url: validImageURL)
        
        imageCell.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private func setupButtons(){
        setupMoreInfoButton(moreInfoButton: moreInfoButton)
    }
    
    private func setupMoreInfoButton(moreInfoButton: UIButton){
        moreInfoButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        moreInfoButton.tintColor = UIColor.black
    }
}



