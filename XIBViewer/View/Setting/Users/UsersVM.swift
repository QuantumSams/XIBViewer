import Foundation

class UsersVM {
    var userList: [UserModel] = []
    var nextURL: String?
    
    func requestNewUsersListAPI(limit: Int = 10, offset: Int = 0, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let request = Endpoints.getUserList(limit: limit, offset: offset).request else {
            completion(.failure(APIErrorTypes.unknownError("Cannot create request from Endpoint - UserVM")))
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            AccountService.getUsersList(request: request) { result in
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
        
        guard let request = Endpoints.loadMoreUserList(fullPath: path).request else {
            completion(.failure(APIErrorTypes.unknownError("Cannot create request from Endpoint - UserVM")))
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            AccountService.getUsersList(request: request) { result in
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
        guard let request = Endpoints.deleteUser(id: id).request else {
            return
        }
            
        AccountService.deleteUser(request: request) { result in
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
