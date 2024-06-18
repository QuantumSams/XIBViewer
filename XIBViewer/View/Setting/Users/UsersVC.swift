//
//  UsersVC.swift
//  XIBViewer
//
//  Created by Huy on 17/6/24.
//

import UIKit

class UsersVC: UIViewController {

    let dummyData = ["Nguyen Van A", "Nguyen Thi B", "Tran Duc C"]
    
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
        let returnCell = UITableViewCell()
        returnCell.textLabel?.text = dummyData[indexPath.row]
        return returnCell
    }
    
    private func setupViews(){
        userTableView.dataSource = self
        userTableView.delegate = self
    }
    
}
