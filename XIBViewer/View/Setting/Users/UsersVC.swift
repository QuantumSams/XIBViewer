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
        DispatchQueue.main.async { [weak self] in
            self?.startIndicatingActivity()
        }
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
        
        returnCell.setData(user: userList[indexPath.row])
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
    private func requestGetListAPI(limit: Int = 100, offset: Int = 0){
        guard let request = Endpoints.getUserList(limit: limit, offset: offset).request else{
            return
        }
        
        AccountService.getUsersList(request: request) { result in
            switch result{
            case .success(let data):
                
                DispatchQueue.main.async { [weak self] in
                    self?.stopIndicatingActivity()
                    self?.userList = data.results
                }
                self.userList = data.results
                self.reloadTable(for: self.userTableView)
            case .failure(let error):
                guard let error = error as? APIErrorTypes else {return}
                
                DispatchQueue.main.async { [weak self] in
                            self?.stopIndicatingActivity()
                        }
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
