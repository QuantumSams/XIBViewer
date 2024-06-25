//
//  UsersVC.swift
//  XIBViewer
//
//  Created by Huy on 17/6/24.
//

import UIKit

class UsersVC: UIViewController {
    
    private let userList: [UserModel] = dummyData

    @IBOutlet private weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension UsersVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let returnCell = userTableView.dequeueReusableCell(withIdentifier: UsersTableCell.getID(), for: indexPath) as! UsersTableCell
        
        returnCell.setData(user: userList[indexPath.row])
        return returnCell
    }
    
    private func setupViews(){
        userTableView.dataSource = self
        userTableView.delegate = self
        userTableView.register(UsersTableCell.getNib(), forCellReuseIdentifier: UsersTableCell.getID())
    }
}
