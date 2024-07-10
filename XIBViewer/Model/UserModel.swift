import Foundation

struct UserModel: Codable{
    
    let id: Int
    let name: String
    let email: String
    let role: RoleModel
}

struct PUTMethodUserModel: Codable{
    let name: String
    let email: String
    let role: PUTMethodRoleModel
}
