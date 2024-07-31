import Foundation

protocol UserListRepository {
    func getUserList(limit: Int, offset: Int, completion: @escaping (Result<UserListModel, Error>) -> Void)

    func appendUserList(url: URL, completion: @escaping (Result<UserListModel, Error>) -> Void)

    func removeOneUser(id: Int, completion: @escaping (Result<Void, Error>) -> Void)
}
