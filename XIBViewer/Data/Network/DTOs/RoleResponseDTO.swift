import Foundation

struct RoleResponseDTO: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [RoleModel]
}
