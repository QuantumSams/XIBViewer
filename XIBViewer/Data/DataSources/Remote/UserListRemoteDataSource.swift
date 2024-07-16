import Foundation

protocol UserListRemoteDataSource {
    func removeOneUser(id: Int, completion: @escaping (Result<Void, any Error>) -> Void)
    func getUserList(limit: Int, offset: Int, completion: @escaping (Result<UserListModel, any Error>) -> Void)
    func appendUserList(url: URL, completion: @escaping (Result<UserListModel, any Error>) -> Void)
}

final class UserListRemoteDataSourceImp: UserListRemoteDataSource {
    let networkService = NetworkService()
    
    func removeOneUser(id: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let request = Endpoints.deleteUser(id: id).request else {
            completion(.failure(APIErrorTypes.unknownError("Cannot create request from Endpoint - UserVM")))
            return
        }
        
        networkService.sendRequest(urlRequest: request){ (result: Result<Void, APIErrorTypes>) in
            switch result{
            case .success(_):
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
        
        networkService.sendRequest(urlRequest: request){ (result: Result<UserListResponseDTO, APIErrorTypes>) in
            switch result{
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
        
        networkService.sendRequest(urlRequest: request){ (result: Result<UserListResponseDTO, APIErrorTypes>) in
            switch result{
            case .success(let data):
                completion(.success(data.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
