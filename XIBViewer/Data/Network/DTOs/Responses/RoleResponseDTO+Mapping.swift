import Foundation

struct RoleResponseDTO: Decodable {
    let id: Int
    let name: String
}

extension RoleResponseDTO {
    func toDomain() -> RoleModel {
        return RoleModel(id: id, name: name)
    }
}
