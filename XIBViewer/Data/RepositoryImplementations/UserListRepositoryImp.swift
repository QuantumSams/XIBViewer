import Foundation

final class UserListRepositoryImp {
    private let remoteDataSource: UserListRemoteDataSource = UserListRemoteDataSourceImp()
}

extension UserListRepositoryImp: UserListRepository {
    func getUserList(limit: Int, offset: Int, completion: @escaping (Result<UserListModel, any Error>) -> Void) {
        remoteDataSource.getUserList(limit: limit, offset: offset, completion: completion)
    }
    
    func appendUserList(url: URL, completion: @escaping (Result<UserListModel, any Error>) -> Void) {
        remoteDataSource.appendUserList(url: url, completion: completion)
    }
    
    func removeOneUser(id: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        remoteDataSource.removeOneUser(id: id, completion: completion)
    }
}
