import Foundation

protocol RoleListRepositoryRemoteDataSource{
    func getRoleList(completion: @escaping ((Result<[RoleModel], any Error>) -> Void))
}


final class RoleListRepositoryRemotedDataSourceImp: RoleListRepositoryRemoteDataSource {
    func getRoleList(completion: @escaping ((Result<[RoleModel], any Error>) -> Void)) {
        RoleService.getRole { result in
            switch result {
            case .success(let data):
                completion(.success(data.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
