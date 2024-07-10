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

struct EditUserErrorResponse: Decodable{
    let email: [String]
}

struct RefreshTokenResponse: Decodable{
    let access: String
}

struct RoleResponseModel: Decodable{
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [RoleModel]
}

struct UsersListResponseModel: Decodable{
    let count: Int
    let next: String?
    let previous: String?
    let results: [UserModel]
}


