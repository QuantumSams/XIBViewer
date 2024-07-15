//
//  RoleRepositoryRemotedDataSourceImp.swift
//  XIBViewer
//
//  Created by Huy on 13/7/24.
//

import Foundation

final class RoleRepositoryRemotedDataSourceImp: RoleListRepository {
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
