import UIKit

class UsersVC: UIViewController {
    
    private var userList: [UserModel] = []{
        didSet{
            self.reloadTable(for: userTableView)
        }
    }

    private var nextURL: String?

    @IBOutlet private weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNewUsersList()
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
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            requestUpdateUserList(url: nextURL)
        }
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
        pullToRefresh()
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            
            
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
          
            if maximumOffset - currentOffset <= 10.0 {
                self.requestUpdateUserList(url: nextURL)
            }
        }
    }
}

extension UsersVC{
    
    @objc func pullToRequestAction(){

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {return}
            
            self.requestNewUsersList(loadingAnimation: false)
            self.userTableView.refreshControl?.endRefreshing()
        }
    }
    
    
    private func pullToRefresh(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(pullToRequestAction),
                                 for: .valueChanged)
        
        userTableView.refreshControl = refreshControl
    }
}


extension UsersVC{
    private func requestNewUsersList(limit: Int = 10, offset: Int = 0, loadingAnimation: Bool = true){
        guard let request = Endpoints.getUserList(limit: limit, offset: offset).request else{
            return
        }
        requestNewUsersListAPI(with: request, loadingAnimation: loadingAnimation)
    }
    
    
    private func requestNewUsersListAPI(with request: URLRequest, loadingAnimation: Bool = true){

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            if loadingAnimation {self.startIndicatingActivity()}
            AccountService.getUsersList(request: request) { result in
                switch result{
                case .success(let data):
                    self.userList = data.results
                    self.nextURL = data.next
                    
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else {return}
                    
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
                if loadingAnimation {self.stopIndicatingActivity()}
            }
        }
    }
    
    private func requestUpdateUserList(url: String?){
        
        guard let url = url,
              let path = URL(string: url),
              let request = Endpoints.loadMoreUserList(fullPath: path).request else{
            return
        }
        requestUpdateUserListAPI(with: request)
    }
    
    private func requestUpdateUserListAPI(with request: URLRequest){

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.startIndicatingActivity()
            AccountService.getUsersList(request: request) { result in
                switch result{
                case .success(let data):
                    self.userList = self.userList + data.results
                    self.nextURL = data.next
                    
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else {return}
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
                self.stopIndicatingActivity()
            }
        }
    }
}

extension UsersVC{
    private func confirmDeletion(id: Int){
        AlertManager.deleteUserConfirm(on: self) { [weak self] choice in
            if choice == true{
                self?.requestDeleteUserAPI(id: id)
            }
        }
    }
    
    private func requestDeleteUserAPI(id: Int){
        guard let request = Endpoints.deleteUser(id: id).request else{
            return
        }
        
        AccountService.deleteUser(request: request) { [weak self] result in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                self.startIndicatingActivity()
                switch result{
                case .success(_):
                    AlertManager.showAlert(on: self,
                                           title: "Request completed",
                                           message: "User has been removed.")
                    
                    self.requestNewUsersList()
                    
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else {return}
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
                self.stopIndicatingActivity()
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
        requestNewUsersList()
    }
}
