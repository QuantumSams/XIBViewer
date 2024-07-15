import Foundation

class LogInVM {
    var password: String?
    var email: String?
    
    let authRepo: AuthenticationRepositiory = AuthenticationRemoteDataSource()
    
        
    func requestLogInAPI(completion: @escaping (Result<SuccessLoginResponseDTO, Error>) -> Void) {
        guard let email = email,
            let password = password
        else {
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
        }
        
        authRepo.login(email: email, password: password) { result in
            switch result {
            case .success(let tokenData):
                completion(.success(tokenData))
                    
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
