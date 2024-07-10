import Foundation

struct RoleModel: Codable{
    let id:Int
    let name:String
}
<<<<<<< HEAD

struct PUTMethodRoleModel:Codable{
    let name: String
}
||||||| 803fb5e


let dummyRole: [RoleModel] = [
    RoleModel(id: 0, name: "Owner"),
    RoleModel(id: 1, name: "Admin"),
    RoleModel(id: 2, name: "User")
]
=======
>>>>>>> feat_Auth_API
