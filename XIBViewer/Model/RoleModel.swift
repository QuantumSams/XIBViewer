import Foundation

struct RoleModel: Codable{
    let id:Int
    let name:String
}


let dummyRole: [RoleModel] = [
    RoleModel(id: 0, name: "Owner"),
    RoleModel(id: 1, name: "Admin"),
    RoleModel(id: 2, name: "User")
]
