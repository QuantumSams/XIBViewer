import Foundation


struct SuccessLoginResponse: Decodable{
    let refresh: String
    let access: String
}
struct ErrorResponse: Decodable{
    let detail: String
}

struct SignupErrorResponse: Decodable{
    let email: [String: String]?
}

struct RoleResponseModel: Decodable{
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [RoleModel]
}
