import Foundation

class UsersVM {
    var userList: [AccountModel] = []
    var nextURL: String?
    
    private let userListRepo: UserListRepository = UserListRepositoryImp()
    
    func requestNewUsersListAPI(limit: Int = 10, offset: Int = 0, completion: @escaping (Result<Void, Error>) -> Void) {
        
        userListRepo.getUserList(limit: limit, offset: offset) {[weak self] result in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.userList = data.results
                    self.nextURL = data.next
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    func requestUpdateUserListAPI(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = nextURL,
              let path = URL(string: url)
        else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            userListRepo.appendUserList(url: path) { result in
                switch result {
                case .success(let data):
                    self.userList = self.userList + data.results
                    self.nextURL = data.next
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func requestDeleteUserAPI(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        userListRepo.removeOneUser(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                        
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
