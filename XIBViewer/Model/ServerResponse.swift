import Foundation


struct SuccessLoginResponse: Decodable{
    let refresh: String
    let access: String
}


struct ErrorResponse: Decodable{
    let detail: String
}

struct RoleResponseModel: Decodable{
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [RoleModel]
}


struct SignupResponse: Decodable{
    let name: String
    let email: String
    let role: Int
    let password: String
}
