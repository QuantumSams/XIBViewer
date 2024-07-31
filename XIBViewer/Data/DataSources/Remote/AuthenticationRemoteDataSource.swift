import Foundation

protocol AuthenticationRemoteDataSource {
    func login(email: String, password: String, completion: @escaping ((Result<SuccessLoginResponseDTO, any Error>) -> Void))
    
    func signUp(name: String, email: String, password: String, role: Int, completion: @escaping (Result<Void, any Error>) -> Void)
    
    func refreshToken(refreshToken: RefreshTokenDTO?, completion: @escaping (Result<AccessTokenDTO, Error>) -> Void)
    
    func accessGuarded(completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthenticationRemoteDataSourceImp: AuthenticationRemoteDataSource {
    let networkService = NetworkService()
    
    func login(email: String, password: String, completion: @escaping ((Result<SuccessLoginResponseDTO, any Error>) -> Void)) {
        let data = LoginDTO(email: email, password: password)
        
        guard let request = Endpoints.login(model: data).request else {
            completion(.failure(APIErrorTypes.unknownError("Endpoint cannot be created - AuthenticationRemoteDataSourceImp")))
            return
        }
        
        networkService.sendRequest(urlRequest: request) { (result: Result<SuccessLoginResponseDTO, APIErrorTypes>) in
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
        
        networkService.sendRequest(urlRequest: request) { (result: Result<Void, APIErrorTypes>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func refreshToken(refreshToken: RefreshTokenDTO?, completion: @escaping (Result<AccessTokenDTO, Error>) -> Void) {
        guard let refreshToken = refreshToken else {
            completion(.failure(APIErrorTypes.dataIsMissing("Refresh token is nil")))
            return
        }
        
        guard let request = Endpoints.refreshToken(model: refreshToken).request else {
            completion(.failure(APIErrorTypes.unknownError("Cannot create request from endpoint - AuthService - refreshToken")))
            return
        }
        
        networkService.sendRequest(urlRequest: request) { (result: Result<AccessTokenDTO, APIErrorTypes>) in
             
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    completion(.success(accessToken))
                        
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func accessGuarded(completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let request = Endpoints.accessGuarded().request else { return }
        networkService.sendRequest(urlRequest: request) { (result: Result<Void, APIErrorTypes>) in
            switch result {
            case .success():
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
