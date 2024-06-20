//
//  UsersTableCell.swift
//  XIBViewer
//
//  Created by Huy on 18/6/24.
//

import UIKit
import SDWebImage

class UsersTableCell: UITableViewCell {
    
    @IBOutlet private weak var moreInfoButton: UIButton!
    @IBOutlet private weak var cellName: UILabel!
    @IBOutlet private weak var cellEmail: UILabel!
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var roleSelectButton: UIButton!
    
    static private let id = "UsersTableCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setupButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
        
        if let validImageURL = user.imageURL{
            imageCell.circularImageFromURL(url: validImageURL)
        }
        else{
            imageCell.image = UIImage(systemName: "person.crop.circle.fill")
        }
        setPopUpButtonInitialValue(popUpButton: roleSelectButton, roleID: user.role.id)
    }
    
    private func setPopUpButtonInitialValue(popUpButton: UIButton, roleID: Int){
        (popUpButton.menu?.children[roleID] as? UIAction)?.state = .on
    }
    
    private func setupButtons(){
        setupLogicPopupButton(popUpButton: roleSelectButton)
        setupVisualPopupButton(popUpButton: roleSelectButton)
        setupMoreInfoButton(moreInfoButton: moreInfoButton)
    }
    private func setupLogicPopupButton(popUpButton: UIButton){
        
        let changeNameClosure = {(incomingAction:UIAction) in
            //MARK: update to DB about role changes
        }
        popUpButton.menu = UIMenu(children: [
            
            UIAction(title: dummyRole[0].name, handler: changeNameClosure),
            UIAction(title: dummyRole[1].name, handler: changeNameClosure),
            UIAction(title: dummyRole[2].name, handler: changeNameClosure)
        ])
        popUpButton.showsMenuAsPrimaryAction = true
        popUpButton.changesSelectionAsPrimaryAction = true
    }
    private func setupVisualPopupButton(popUpButton: UIButton){
        
        popUpButton.layer.borderWidth = Constant.PopUpButtonConstant.borderWidth
        popUpButton.layer.cornerRadius = Constant.PopUpButtonConstant.cornerRadius
        popUpButton.layer.borderColor = Constant.PopUpButtonConstant.borderColor.cgColor
        popUpButton.backgroundColor = Constant.PopUpButtonConstant.backgroundColor
        popUpButton.tintColor = Constant.PopUpButtonConstant.tintColor
    }
    
    private func setupMoreInfoButton(moreInfoButton: UIButton){
        moreInfoButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        moreInfoButton.tintColor = UIColor.black
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

