import Foundation


struct SignupModel: Codable{
    let name: String
    let email: String
    let role: RoleModel?
    let password: String
}
