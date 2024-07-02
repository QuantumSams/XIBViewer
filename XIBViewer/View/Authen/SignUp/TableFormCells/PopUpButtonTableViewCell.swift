//
//  PopUpButtonTableViewCell.swift
//  XIBViewer
//
//  Created by Huy on 2/7/24.
//

import UIKit

class PopUpButtonTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var popUpButton: UIButton!
    
    static let id: String = "PopUpButtonTableViewCell"
    static var nib: UINib {
        UINib(nibName: "PopUpButtonTableViewCell", bundle: nil)
    }
    
    private var formType: PopupButtonFieldComponent?
    var delegate: cellCommunicationDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PopUpButtonTableViewCell{
    
    func setupCell(formType: PopupButtonFieldComponent){
        guard delegate != nil else {
            fatalError("Delegate is nil")
        }
        self.formType = formType
        label.text = formType.label
        setupPopUpButton(for: popUpButton)
    }
    
    private func setupPopUpButton(for button: UIButton){
        
        button.setupButton(tintColor: Constant.PopUpButtonConstant.tintColor,
                           borderColor: Constant.PopUpButtonConstant.borderColor,
                           cornerRadius: Constant.PopUpButtonConstant.cornerRadius,
                           borderWidth: Constant.PopUpButtonConstant.borderWidth,
                           maskToBound: false)
        
            popUpButton.menu = delegate?.contructPopUpChoices(
                from: formType!.choices,
                actionWhenChoiceChanged: PopUpButtonSelected())
        
            popUpButton.showsMenuAsPrimaryAction = true
            popUpButton.changesSelectionAsPrimaryAction = true
            (popUpButton.menu?.children[0] as? UIAction)?.state = .on
    }
}

extension PopUpButtonTableViewCell{
    private func PopUpButtonSelected() -> (UIAction) -> Void{
        guard let delegate else{
            fatalError("Delegate is nil")
        }
        
        return{ (chosen: UIAction) in
            
            guard let roleID = RoleSingleton.accessSingleton.getID(from: chosen.title) else{
                fatalError("Cannot convert from value to key using RoleSingleton")
            }
            delegate.setData(id: self.formType!.id, value: roleID)
        }
        
    }
}
