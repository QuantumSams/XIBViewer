import Foundation

protocol AuthenticationRepositiory {
    // login
    func login(email: String, password: String, completion: @escaping ((Result<SuccessLoginResponseDTO, Error>) -> Void))
    
    // signUp
    func signUp(name: String,
                email: String,
                password: String,
                role: Int,
                completion: @escaping (Result<Void, Error>) -> Void)
    
    // request refresh token

    // TODO: GUARDED
}
