import Foundation

protocol RoleListRepository {
    func getRoleList(completion: @escaping ((Result<[RoleModel], Error>) -> Void))
}
