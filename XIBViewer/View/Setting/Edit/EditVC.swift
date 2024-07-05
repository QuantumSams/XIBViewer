//
//  EditVC.swift
//  XIBViewer
//
//  Created by Huy on 4/7/24.
//

import UIKit

class EditVC: UIViewController {
    
    private var existingData: UserModel?
    private let editForm = TableForm.edit.getForm
    private let editOrder = TableForm.edit.order
    
    init(existingData: UserModel?) {
        self.existingData = existingData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet private weak var editTableForm: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setInitalValueForEditField(from: existingData)
    }
    @objc private func cancelButtonSelected(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditVC{
    private func setup(){
        setupTable(for: editTableForm)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonSelected))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
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
    func setInitalValueForEditField(from data: UserModel?){
        guard let data = data else{
            return
        }
        
        editForm["Email"]?.value = data.email
        editForm["Name"]?.value = data.name
        editForm["Role"]?.value = data.role.id
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editForm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let field = editForm[editOrder[indexPath.row]]  else{
            fatalError("Cannot get field from editForm with key in editOrder")
        }
        
        
        switch field.fieldType{
            
        case .name, .email:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFormCell.id, for: indexPath) as? TextFormCell
            else {
                fatalError("Cannot create TextFormCell in EditVC")
            }
            cell.setupCell(form: field as! TextFormCellModel)
            return cell
            
        
        case .roleSelection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopupButtonFormCell.id, for: indexPath) as? PopupButtonFormCell
            else {
                fatalError("Cannot create PopupButtonFormCell in EditVC")
            }
            cell.delegate = self
            cell.setupCell(formType: field as! PopupButtonFormCellModel)
            
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
