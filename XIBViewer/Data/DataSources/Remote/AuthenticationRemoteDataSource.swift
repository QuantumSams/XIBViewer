import Foundation

protocol AuthenticationRemoteDataSource{
    func login(email: String, password: String, completion: @escaping ((Result<SuccessLoginResponseDTO, any Error>) -> Void))
    
    func signUp(name: String, email: String, password: String, role: Int, completion: @escaping (Result<Void, any Error>) -> Void)
}

final class AuthenticationRemoteDataSourceImp: AuthenticationRemoteDataSource {
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
    
    func signUp(name: String, email: String, password: String, role: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        
        let data = SignUpDTO(name: name,
                             email: email, role: role, password: password)
        
        guard let request = Endpoints.signup(model: data).request else {
            completion(.failure(APIErrorTypes.unknownError("Request cannot be fullfilled - Endpoint error")))
            return
        }
        
        AuthService.signUp(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
