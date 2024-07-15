import Foundation

final class AuthenticationRepositoryImp {
    private let remoteDataSource: AuthenticationRemoteDataSource = AuthenticationRemoteDataSourceImp()
}

extension AuthenticationRepositoryImp: AuthenticationRepository {
    func login(email: String, password: String, completion: @escaping ((Result<SuccessLoginResponseDTO, any Error>) -> Void)) {
        remoteDataSource.login(email: email, password: password, completion: completion)
    }

    func signUp(name: String, email: String, password: String, role: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        remoteDataSource.signUp(name: name, email: email, password: password, role: role, completion: completion)
    }
}
