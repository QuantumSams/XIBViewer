import Foundation


protocol RoleRepository{
    func getRoleList(completion: @escaping ((Result<[RoleModel], Error>) -> Void))
}
