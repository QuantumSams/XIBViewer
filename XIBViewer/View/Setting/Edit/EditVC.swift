//
//  EditVC.swift
//  XIBViewer
//
//  Created by Huy on 4/7/24.
//

import UIKit

class EditVC: UIViewController {
    
//    var existingData: UserModel
    let editForm = TableForm.edit.getForm
    
//    init(existingData: UserModel) {
//        self.existingData = existingData
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @IBOutlet private weak var editTableForm: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension EditVC{
    private func setup(){
        setupTable(for: editTableForm)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(cancelButtonSelected))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(saveButtonPressed))
    }
    
    @objc private func cancelButtonSelected(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonPressed(){
        print("Save selected")
        
    }
    
    private func setupTable(for table:UITableView){
        table.delegate = self
        table.dataSource = self
        navigationItem.title = "Edit information"
        self.isModalInPresentation = true
        table.register(TextFormCell.nib, forCellReuseIdentifier: TextFormCell.id)
        table.register(PopupButtonFormCell.nib, forCellReuseIdentifier: PopupButtonFormCell.id)
    }
}


extension EditVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editForm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch editForm[indexPath.row].fieldType{
            
        case .name, .email:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFormCell.id, for: indexPath) as? TextFormCell
            else {
                fatalError("Cannot create TextFormCell in EditVC")
            }
            
            cell.setupCell(form: editForm[indexPath.row] as! TextFormCellModel)
            return cell
            
        
        case .roleSelection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopupButtonFormCell.id, for: indexPath) as? PopupButtonFormCell
            else {
                fatalError("Cannot create PopupButtonFormCell in EditVC")
            }
            cell.delegate = self
            cell.setupCell(formType: editForm[indexPath.row] as! PopupButtonFormCellModel)
            
            return cell
        
        default:
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        }
    }
}

extension EditVC: TableFromPopUpMenuDelegate{
    func TableFormPopUpMenuConstructor(from literalStringChoices: [String],
                                       actionWhenChoiceChanged: @escaping UIActionHandler) -> UIMenu{
        var actions: [UIAction] = []
        for choice in literalStringChoices{
            actions.append(UIAction(title: choice, handler: actionWhenChoiceChanged))
        }
        return UIMenu(children: actions)
    }
}
