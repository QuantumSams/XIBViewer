import Foundation

struct UserListResponseDTO: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [UserModel]
}

extension UserListResponseDTO{
    func toDomain() -> UserListModel{
        UserListModel(next: next, results: results)
    }
}
