import Foundation

protocol AuthenticationRepository {
    func login(email: String, password: String, completion: @escaping ((Result<Void, Error>) -> Void))
    
    func signUp(name: String,
                email: String,
                password: String,
                role: Int,
                completion: @escaping (Result<Void, Error>) -> Void)
    
    func logout()
    
    func getAccessToken(completion: @escaping (Result<Void, Error>) -> Void)
    
    func getRefreshToken() -> RefreshTokenDTO
}
