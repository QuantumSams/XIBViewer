import Foundation

protocol RoleListRepositoryRemoteDataSource {
    func getRoleList(completion: @escaping ((Result<[RoleModel], any Error>) -> Void))
}

final class RoleListRepositoryRemotedDataSourceImp: RoleListRepositoryRemoteDataSource {
    let networkService = NetworkService()

    func getRoleList(completion: @escaping ((Result<[RoleModel], any Error>) -> Void)) {
        guard let request = Endpoints.getRole().request else { return }

        networkService.sendRequest(urlRequest: request) { (result: Result<RoleListResponseDTO, APIErrorTypes>) in
            switch result {
            case .success(let data):
                completion(.success(data.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
