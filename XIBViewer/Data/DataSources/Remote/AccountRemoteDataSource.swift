import Foundation

protocol AccountRemoteDataSource {
    func getOneUser(completion: @escaping (Result<AccountModel, any Error>) -> Void)
    func editOneUser(for data: EditUserDTO, completion: @escaping (Result<AccountModel, Error>) -> Void)
}

final class AccountRemoteDataSourceImp: AccountRemoteDataSource {
    let networkService = NetworkService()
    
    func getOneUser(completion: @escaping (Result<AccountModel, any Error>) -> Void) {
        guard let request = Endpoints.getAccountData().request else { return }
        
        networkService.sendRequest(urlRequest: request) { (result: Result<AccountResponseDTO, APIErrorTypes>) in
            
            switch result {
            case .success(let adminUser):
                completion(.success(adminUser.toDomain()))
        
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editOneUser(for data: EditUserDTO, completion: @escaping (Result<AccountModel, Error>) -> Void) {
        guard let request = Endpoints.editUser(model: data.data, id: data.id).request else {
            completion(.failure(APIErrorTypes.unknownError("Request cannot be fullfilled - Endpoint error")))
            return
        }
        
        networkService.sendRequest(urlRequest: request) { (result: Result<AccountResponseDTO, APIErrorTypes>) in
            
            switch result {
            case .success(let newUserData):
                completion(.success(newUserData.toDomain()))
                    
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
