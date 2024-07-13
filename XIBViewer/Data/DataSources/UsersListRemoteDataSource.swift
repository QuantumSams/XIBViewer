import Foundation

final class UsersListRemoteDataSourceImp: UsersListRepository {
    func removeOneUser(id: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let request = Endpoints.deleteUser(id: id).request else {
            return
        }
                
        AccountService.deleteUser(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
                            
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserList(limit: Int, offset: Int, completion: @escaping (Result<UserListModel, any Error>) -> Void) {
        guard let request = Endpoints.getUserList(limit: limit, offset: offset).request else {
            completion(.failure(APIErrorTypes.unknownError("Cannot create request from Endpoint - UserVM")))
            return
        }
        AccountService.getUsersList(request: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func appendUserList(url: URL, completion: @escaping (Result<UserListModel, any Error>) -> Void) {
        guard let request = Endpoints.loadMoreUserList(fullPath: url).request else {
            completion(.failure(APIErrorTypes.unknownError("Cannot create request from Endpoint - UserVM")))
            return
        }
            
        AccountService.getUsersList(request: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data.toDomain()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
