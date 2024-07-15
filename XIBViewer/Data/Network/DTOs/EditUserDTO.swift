import Foundation

struct EditUserDTO: Encodable {
    let id: Int
    let data: EditUserDataDTO
}

struct EditUserDataDTO: Encodable {
    let name: String
    let email: String
    let role: EditUserRoleDTO
}

extension EditUserDataDTO {
    struct EditUserRoleDTO: Encodable {
        let name: String
    }
}

extension EditUserDTO {
    init(for user: UserModel) {
        self.id = user.id
        self.data = EditUserDataDTO(name: user.name, email: user.email, role: user.role)
    }
}

extension EditUserDataDTO {
    init(name: String, email: String, role: RoleModel) {
        self.name = name
        self.email = email
        self.role = EditUserRoleDTO(role: role)
    }
}

extension EditUserDataDTO.EditUserRoleDTO {
    init(role: RoleModel) {
        self.name = role.name
    }
}
