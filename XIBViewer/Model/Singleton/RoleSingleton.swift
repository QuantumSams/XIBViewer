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
    
    
    func getIDFromName(name: String) -> RoleModel?{
        var returnRole: RoleModel?
        roleList.forEach { role in
            if name == role.name{
                returnRole = role
            }
        }
        return returnRole
    }
}
