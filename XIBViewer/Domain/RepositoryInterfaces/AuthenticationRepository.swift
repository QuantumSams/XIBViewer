import Foundation

protocol AuthenticationRepository {
    // login
    func login(email: String, password: String, completion: @escaping ((Result<Void, Error>) -> Void))
    
    // signUp
    func signUp(name: String,
                email: String,
                password: String,
                role: Int,
                completion: @escaping (Result<Void, Error>) -> Void)
    
    func getAccessToken(completion: @escaping(Result<Void, Error>) -> Void)
    
    func logout()
    
    func getRefreshToken() -> RefreshTokenDTO
    
    //func getAccessToken

    // TODO: GUARDED
}
