import Foundation

protocol AccountRepository {
    func getOneUser(completion: @escaping (Result<AccountModel, Error>) -> Void)
    
    func editOneUser(for: EditUserDTO, completion: @escaping (Result<AccountModel, Error>) -> Void)
}
