import Foundation

struct SuccessLoginResponseDTO: Decodable {
    let refresh: String
    let access: String
}

extension SuccessLoginResponseDTO{
    func toDomain() -> TokenModel{
        return TokenModel(refresh: refresh, access: access)
    }
}
