import Foundation


class RoleSingleton{
    private init() {}
    static let accessSingleton = RoleSingleton()
    private var roleList: [RoleModel] = []
}


extension RoleSingleton{
    func setRole(newRole: [RoleModel]){
        self.roleList = newRole
    }
    
    func getRole() -> [RoleModel]{
        self.roleList
    }
}
