import Foundation

final class RoleListRepositoryImp{
    private let remoteDataSource: RoleListRepositoryRemoteDataSource = RoleListRepositoryRemotedDataSourceImp()
}

extension RoleListRepositoryImp: RoleListRepository{
    func getRoleList(completion: @escaping ((Result<[RoleModel], any Error>) -> Void)) {
        remoteDataSource.getRoleList(completion: completion)
    }
}
