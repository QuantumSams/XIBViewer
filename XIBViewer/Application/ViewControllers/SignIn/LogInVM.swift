import Foundation

class LogInVM {
    var password: String?
    var email: String?
    
    let authRepo: AuthenticationRepository = AuthenticationRepositoryImp()
    
    func requestLogInAPI(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = email,
              let password = password
        else {
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
        }
        
        authRepo.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                        
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
