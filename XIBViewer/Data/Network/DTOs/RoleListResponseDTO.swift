import Foundation

struct RoleListResponseDTO: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [RoleResponseDTO]
}

extension RoleListResponseDTO {
    func toDomain() -> [RoleModel] {
        return results.map { $0.toDomain() }
    }
}
