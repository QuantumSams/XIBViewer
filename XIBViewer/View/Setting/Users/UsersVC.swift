//
//  UsersVC.swift
//  XIBViewer
//
//  Created by Huy on 17/6/24.
//

import UIKit

class UsersVC: UIViewController {

    let dummyData:[UserModel] = [
        UserModel(name: "Jack NinetySeven", email: "j97@gmail.com", imageURL: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=3687&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
        
        UserModel(name: "Hugh Jackman", email: "jackman_hugh@gmail.com")
    ]
    
    @IBOutlet private weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension UsersVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let returnCell = userTableView.dequeueReusableCell(withIdentifier: UsersTableCell.getID(), for: indexPath) as! UsersTableCell
        
        returnCell.setData(user: dummyData[indexPath.row])
        return returnCell
    }
    
    private func setupViews(){
        userTableView.dataSource = self
        userTableView.delegate = self
        userTableView.register(UsersTableCell.getNib(), forCellReuseIdentifier: UsersTableCell.getID())
    }
}
