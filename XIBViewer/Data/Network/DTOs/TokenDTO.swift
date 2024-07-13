import Foundation


struct RefreshTokenDTO: Codable{
    let refresh: String
}

struct AccessTokenDTO: Decodable{
    let access: String
}


