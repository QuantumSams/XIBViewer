import SDWebImage
import UIKit

protocol UserTableCellDelegate {
    func moreInfoButtonPressed(index: Int)
}

class UsersTableCell: UITableViewCell {
    // MARK: - PROPERTIES

    private static let id = "UsersTableCell"
    private var index: Int = .init()
    var delegate: UserTableCellDelegate?
    
    // MARK: - OUTLETS

    @IBOutlet private var moreInfoButton: UIButton!
    @IBOutlet private var cellName: UILabel!
    @IBOutlet private var cellEmail: UILabel!
    @IBOutlet private var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction private func moreInfoButtonSelected(_ sender: UIButton) {
        guard let delegate = delegate else {
            print("userTableCell delegate hasn't been assigned")
            return
        }
        delegate.moreInfoButtonPressed(index: index)
    }
}

extension UsersTableCell {
    static func getNib() -> UINib {
        UINib(nibName: "UsersTableCell", bundle: nil)
    }
    
    static func getID() -> String {
        id
    }
    
    func setData(user: AccountModel, indexPath: Int) {
        cellName.text = user.name
        cellEmail.text = user.email
        index = indexPath
//
        // load image from URL
        // imageCell.circularImageFromURL(url: validImageURL)
        
        imageCell.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private func setupButtons() {
        setupMoreInfoButton(moreInfoButton: moreInfoButton)
    }
    
    private func setupMoreInfoButton(moreInfoButton: UIButton) {
        moreInfoButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        moreInfoButton.tintColor = UIColor.tintColor
    }
}
