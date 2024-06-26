import Foundation


struct SuccessLoginResponse: Decodable{
    let refresh: String
    let access: String
}


struct ErrorResponse: Decodable{
    let detail: String
}
