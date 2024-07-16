import Foundation

struct UserResponseDTO: Decodable {
    let id: Int
    let name: String
    let email: String
    let role: RoleResponseDTO
    var imageURL: URL? = nil
}

extension UserResponseDTO {
    func toDomain() -> AccountModel {
        return AccountModel(id: id, name: name, email: email, role: role.toDomain())
    }
}
