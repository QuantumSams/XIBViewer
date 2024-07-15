import Foundation

final class AuthenticationRemoteDataSource: AuthenticationRepositiory {
    func login(email: String, password: String, completion: @escaping ((Result<SuccessLoginResponseDTO, any Error>) -> Void)) {
        
        let data = LoginDTO(email: email, password: password)
        
        guard let request = Endpoints.login(model: data).request else {
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
