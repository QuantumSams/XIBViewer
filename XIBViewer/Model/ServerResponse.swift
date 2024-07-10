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

<<<<<<< HEAD
struct EditUserErrorResponse: Decodable{
    let email: [String]
}

struct RefreshTokenResponse: Decodable{
    let access: String
}

||||||| 803fb5e
=======
struct RefreshTokenResponse: Decodable{
    let access: String
}

>>>>>>> feat_Auth_API
struct RoleResponseModel: Decodable{
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [RoleModel]
}

