import UIKit

class UsersVC: UIViewController {
    
    private var userList: [UserModel] = []{
        didSet{
            self.reloadTable(for: userTableView)
        }
    }

    @IBOutlet private weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestGetListAPI()
        setupViews()
    }
}

extension UsersVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let returnCell = userTableView.dequeueReusableCell(withIdentifier: UsersTableCell.getID(), for: indexPath) as! UsersTableCell
        
        returnCell.setData(user: userList[indexPath.row], indexPath: indexPath.item)
        returnCell.delegate = self
        return returnCell
    }
    
    private func reloadTable(for table: UITableView){
        DispatchQueue.main.async {
            table.reloadData()
        }
    }
    
    private func setupViews(){
        userTableView.dataSource = self
        userTableView.delegate = self
        userTableView.register(UsersTableCell.getNib(), forCellReuseIdentifier: UsersTableCell.getID())
    }
}


extension UsersVC{
    private func requestGetListAPI(limit: Int = 10, offset: Int = 0){
        guard let request = Endpoints.getUserList(limit: limit, offset: offset).request else{
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.startIndicatingActivity()
            AccountService.getUsersList(request: request) { result in
                switch result{
                case .success(let data):
                    self.stopIndicatingActivity()
                    self.userList = data.results
                    self.reloadTable(for: self.userTableView)
                    
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else {return}
                    self.stopIndicatingActivity()
                    switch error{
                    case .serverError(let string):
                        AlertManager.showServerErrorResponse(on: self, message: string)
                    case .decodingError(let string),
                            .unknownError(let string):
                        AlertManager.showDevelopmentError(on: self, message: string, errorType: .decodingError())
                    case .deviceError(let string):
                        AlertManager.showDeviceError(on: self, message: string)
                    }
                }
            }
        }
    }
}

extension UsersVC{
    private func confirmDeletion(id: Int){
        AlertManager.deleteUserConfirm(on: self) { [weak self] choice in
            switch choice{
            case true:
                self?.requestDeleteUserAPI(id: id)
            case false:
                break
            }
        }
    }
    
    private func requestDeleteUserAPI(id: Int){
        guard let request = Endpoints.deleteUser(id: id).request else{
            return
        }
        
        AccountService.deleteUser(request: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                
                self.startIndicatingActivity()
                
                switch result{
                case .success():
                    AlertManager.showAlert(on: self,
                                           title: "Request completed",
                                           message: "User has been removed.")
                    
                    self.stopIndicatingActivity()
                    self.requestGetListAPI()
                    
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else {return}
                    self.stopIndicatingActivity()
                    switch error{
                    case .serverError(let string):
                        AlertManager.showServerErrorResponse(on: self, message: string)
                    case .decodingError(let string),
                            .unknownError(let string):
                        AlertManager.showDevelopmentError(on: self, message: string, errorType: .decodingError())
                    case .deviceError(let string):
                        AlertManager.showDeviceError(on: self, message: string)
                    }
                }
            }
        }
    }
}

extension UsersVC: UserTableCellDelegate{
    func moreInfoButtonPressed(index: Int) {
        AlertManager.userMenu(on: self) { [weak self] actionType in
            guard let self = self else {return}
            switch actionType{
            case .edit:
                self.presentEditVC(with: self.userList[index])
            case .delete:
                confirmDeletion(id: self.userList[index].id)
            case .cancel:
                break
            }
        }
    }
}

extension UsersVC: EditVCDelegate{
    private func presentEditVC(with data: UserModel){
        let vc = EditVC(existingData: data)
        vc.delegate = self
        self.presentCustomVCWithNavigationController(toVC: vc)
    }
    func doneEditing(send newUserData: UserModel) {
        requestGetListAPI()
    }
}
