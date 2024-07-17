import Foundation

struct AccountModel: Codable {
    let id: Int
    let name: String
    let email: String
    let role: RoleModel
    var imageURL: URL? = nil
}

extension AccountModel {
    func toEditMethod() -> EditUserDTO {
        EditUserDTO(for: self)
    }
}
