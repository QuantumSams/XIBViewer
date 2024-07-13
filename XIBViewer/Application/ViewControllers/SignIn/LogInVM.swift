import Foundation

class LogInVM {
    var password: String?
    var email: String?
    
    private func getDataFromTableFields() -> LoginModel? {
        guard let email = email,
              let password = password
        else {
            return nil
        }
        return LoginModel(email: email, password: password)
    }
        
    func requestLogInAPI(completion: @escaping (Result<SuccessLoginResponseDTO, Error>) -> Void) {
        guard let loginRequestData = getDataFromTableFields() else {
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
        }
        guard let request = Endpoints.login(model: loginRequestData).request else {
            completion(.failure(APIErrorTypes.unknownError("Endpoint cannot be created - SignInVC")))
            return
        }
            
        AuthService.login(request: request) { result in
            switch result {
            case .success(let tokenData):
                completion(.success(tokenData))
                    
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
