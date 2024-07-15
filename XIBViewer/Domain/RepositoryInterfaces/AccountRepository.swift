import Foundation

protocol AccountRepository {
    // MARK: - Get data of one user
    
    func getOneUser(completion: @escaping (Result<UserModel, Error>) -> Void)
    
    func editOneUser(for: EditUserDTO, completion: @escaping (Result<UserModel, Error>) -> Void)


    
}
