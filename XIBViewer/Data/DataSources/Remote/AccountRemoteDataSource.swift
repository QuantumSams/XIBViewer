import Foundation

protocol AccountRemoteDataSource{
    func getOneUser(completion: @escaping (Result<UserModel, any Error>) -> Void)
    func editOneUser(for data: EditUserDTO, completion: @escaping (Result<UserModel, Error>) -> Void)
}

final class AccountRemoteDataSourceImp: AccountRemoteDataSource {
    func getOneUser(completion: @escaping (Result<UserModel, any Error>) -> Void) {
        AccountService.getAccount { result in
            switch result {
            case .success(let adminUser):
                completion(.success(adminUser))
        
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editOneUser(for data: EditUserDTO, completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let request = Endpoints.editUser(model: data.data, id: data.id).request else {
            completion(.failure(APIErrorTypes.unknownError("Request cannot be fullfilled - Endpoint error")))
            return
        }
            
        AccountService.editAccount(request: request) { result in
            
            switch result {
            case .success(let newUserData):
                
                completion(.success(newUserData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
