import UIKit

class UsersVC: UIViewController {
    // MARK: - VARIABLES

    private let viewModel: UsersVM

    // MARK: - OUTLETS

    @IBOutlet private var userTableView: UITableView!

    // MARK: - LIFECYCLE

    init() {
        viewModel = UsersVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewList(limit: 20)
        setupViews()
    }
}

// MARK: - DELEGATE/DATASOURCE CONFORM

// UITableViewDataSource - UITableViewDelegate
extension UsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = userTableView.dequeueReusableCell(withIdentifier: UsersTableCell.getID(), for: indexPath) as! UsersTableCell
        
        returnCell.setData(user: viewModel.userList[indexPath.row], indexPath: indexPath.item)
        returnCell.delegate = self
        return returnCell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            if maximumOffset - currentOffset <= 10.0 {
                self.updateList()
            }
        }
    }
}

// UserTableCellDelegate
extension UsersVC: UserTableCellDelegate {
    func moreInfoButtonPressed(index: Int) {
        AlertManager.userMenu(on: self) { [weak self] actionType in
            guard let self = self else { return }
            switch actionType {
            case .edit:
                self.presentEditVC(with: self.viewModel.userList[index])
            case .delete:
                confirmDeletion(id: self.viewModel.userList[index].id, index: index)
            case .cancel:
                break
            }
        }
    }
}

// EditVCDelegate
extension UsersVC: EditVCDelegate {
    private func presentEditVC(with data: AccountModel) {
        let vc = EditVC(existingData: data, delegate: self)
        presentCustomVCWithNavigationController(toVC: vc)
    }

    func doneEditing(send newUserData: AccountModel) {
        getNewList(limit: 20, loadingAnimation: true)
    }
}

// MARK: - ADDITIONAL METHODS

// setup view
extension UsersVC {
    private func setupViews() {
        userTableView.dataSource = self
        userTableView.delegate = self
        userTableView.register(UsersTableCell.getNib(), forCellReuseIdentifier: UsersTableCell.getID())
        pullToRefreshSetup()
    }
    
    @objc func pullToRequestAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            self.getNewList(limit: 20, loadingAnimation: false)
            self.userTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func pullToRefreshSetup() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(pullToRequestAction),
                                 for: .valueChanged)
        userTableView.refreshControl = refreshControl
    }

    private func reloadTable(for table: UITableView) {
        DispatchQueue.main.async {
            table.reloadData()
        }
    }
    
    private func confirmDeletion(id: Int, index: Int) {
        AlertManager.deleteUserConfirm(on: self) { [weak self] choice in
            if choice == true {
                self?.deleteUser(id: id)
                self?.viewModel.userList.remove(at: index)
                let indexPath = IndexPath(item: index, section: 0)
                self?.userTableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
    }
}

// API Calling
extension UsersVC {
    private func getNewList(limit: Int = 10, offset: Int = 0, loadingAnimation: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if loadingAnimation { self.startIndicatingActivity() }
            viewModel.requestNewUsersListAPI(limit: limit, offset: offset) { result in
                switch result {
                case .success():
                    if loadingAnimation { self.stopIndicatingActivity() }
                    self.reloadTable(for: self.userTableView)
                case .failure(let error):
                    if loadingAnimation { self.stopIndicatingActivity() }
                    guard let error = error as? APIErrorTypes else { return }
                    AlertManager.alertOnAPIError(with: error, on: self)
                }
            }
        }
    }
    
    private func updateList() {
        if viewModel.nextURL == nil { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.startIndicatingActivity()
            viewModel.requestUpdateUserListAPI { result in
                switch result {
                case .success():
                    self.reloadTable(for: self.userTableView)
                    self.stopIndicatingActivity()
                    
                case .failure(let error):
                    self.stopIndicatingActivity()
                    guard let error = error as? APIErrorTypes else { return }
                    AlertManager.alertOnAPIError(with: error, on: self)
                }
            }
        }
    }

    private func deleteUser(id: Int) {
        startIndicatingActivity()
        viewModel.requestDeleteUserAPI(id: id) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success:
                    AlertManager.showAlert(on: self,
                                           title: "Request completed",
                                           message: "User has been removed.")
                    
                case .failure(let error):
                    guard let error = error as? APIErrorTypes else { return }
                    AlertManager.alertOnAPIError(with: error, on: self)
                }
                self.stopIndicatingActivity()
            }
        }
    }
}
