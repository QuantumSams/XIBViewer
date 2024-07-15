import Foundation

struct ErrorResponseDTO: Decodable {
    let detail: String
}

struct EditUserErrorResponse: Decodable {
    let email: [String]
}

struct SignupErrorResponseDTO: Decodable {
    let email: [String: String]?
}
