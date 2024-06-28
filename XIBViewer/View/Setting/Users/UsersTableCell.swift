//
//  UsersTableCell.swift
//  XIBViewer
//
//  Created by Huy on 18/6/24.
//

import UIKit
import SDWebImage

class UsersTableCell: UITableViewCell {
    
    let popUpButtonTappedClosure: (UIAction) -> Void
    
    init(popUpButtonTappedClosure passingClosure: @escaping (UIAction) -> Void){
        self.popUpButtonTappedClosure = passingClosure
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
//    private func convertRoleModel(from: [RoleModel]) -> [UIAction]{
//        let changeNameClosure = {(incomingAction: UIAction) in
//            //TODO: update to DB about role changes
//        }
//        var out: [UIAction] = []
//        
//        from.forEach { role in
//            out.append(UIAction(title: role.name, handler: changeNameClosure))
//        }
//        return out
//    }
    
    private func setupLogicPopupButton(popUpButton: UIButton){
    
        popUpButton.menu = UIMenu(
            children: RoleSingleton.accessSingleton.convertToUIAction(handler: popUpButtonTappedClosure)
        )
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



