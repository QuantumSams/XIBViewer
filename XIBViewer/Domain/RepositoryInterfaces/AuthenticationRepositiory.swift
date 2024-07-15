import Foundation

protocol AuthenticationRepositiory {
    // login
    func login(email: String, password: String, completion: @escaping ((Result<SuccessLoginResponseDTO, Error>) -> Void))
    
    // signUp
    // request refresh token

    // TODO: GUARDED
}
