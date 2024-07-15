import Foundation

struct UserModel: Codable{
    
    let id: Int
    let name: String
    let email: String
    let role: RoleModel
    var imageURL: URL? = nil
}

extension UserModel{
    func toEditMethod() -> EditUserDTO{
        EditUserDTO(for: self)
    }
}
