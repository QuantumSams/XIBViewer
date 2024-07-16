import Foundation

struct SignUpDTO: Codable{
    let name: String
    let email: String
    let role: Int
    let password: String
}
