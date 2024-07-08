//
//  PopUpButtonTableViewCell.swift
//  XIBViewer
//
//  Created by Huy on 2/7/24.
//

import UIKit

class PopupButtonFormCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var popUpButton: UIButton!
    
    static let id: String = "PopupButtonFormCell"
    static var nib: UINib {
        UINib(nibName: "PopupButtonFormCell", bundle: nil)
    }
    
    private var formType: PopupButtonFormCellModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PopupButtonFormCell{
    
    func setupCell(formType: PopupButtonFormCellModel){
       
        self.formType = formType
        label.text = formType.label
        setupPopUpButton(for: popUpButton)
    }
    
    private func setupPopUpButton(for button: UIButton){
        
//        button.setupButton(tintColor: Constant.PopUpButtonConstant.tintColor,
//                           borderColor: Constant.PopUpButtonConstant.borderColor,
//                           cornerRadius: Constant.PopUpButtonConstant.cornerRadius,
//                           borderWidth: Constant.PopUpButtonConstant.borderWidth,
//                           maskToBound: false)
        
        
        
        
        var child: [UIAction] = []
        for choice in RoleSingleton.accessSingleton.getRole(){
            child.append(UIAction(title: choice.name, identifier: .init(rawValue: String(choice.id)), handler: PopUpButtonSelected()))
        }
        
//        popUpButton.menu = RoleSingleton.accessSingleton.TableFormPopUpMenuConstructor(actionWhenChoiceChanged: PopUpButtonSelected())
        popUpButton.menu = UIMenu(children: child)
        
        
        
        popUpButton.showsMenuAsPrimaryAction = true
        popUpButton.changesSelectionAsPrimaryAction = true
        saveInitialValue()

    }
}

extension PopupButtonFormCell{
    private func PopUpButtonSelected() -> (UIAction) -> Void{
        print("HERE")
        
        return{ (chosen: UIAction) in
            guard let selectedRoleID = Int(chosen.identifier.rawValue) else{
                fatalError("ID of selected role cannot be resolved")
            }
            self.formType?.value = RoleModel(id: selectedRoleID, name: chosen.title)
        }
        
    }
    
    private func saveInitialValue(){
        if let initialRoleID = formType?.value as? Int {

            let actionIdentifier: UIAction.Identifier = .init(String(initialRoleID))
            
            let actionList: [UIAction] = (popUpButton.menu?.children as! [UIAction])
            
            let action = actionList.first { action in
                action.identifier == actionIdentifier
            }
            action?.state = .on
            return
        }
        
        let action: UIAction = popUpButton.menu?.selectedElements.first as! UIAction as UIAction
        self.formType?.value = Int(action.identifier.rawValue)
    }
}
