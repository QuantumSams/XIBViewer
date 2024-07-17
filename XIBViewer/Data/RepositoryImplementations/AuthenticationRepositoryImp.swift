import Foundation

final class AuthenticationRepositoryImp {
    private let remoteDataSource: AuthenticationRemoteDataSource = AuthenticationRemoteDataSourceImp()

    private let localDataSource: AuthenticationLocalDataSource = AuthenticationLocalDataSourceImp()
}

extension AuthenticationRepositoryImp: AuthenticationRepository {
    func login(email: String, password: String, completion: @escaping ((Result<Void, any Error>) -> Void)) {
        remoteDataSource.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let data):
                self?.localDataSource.setInitialToken(
                    access: AccessTokenDTO(access: data.access),
                    refresh: RefreshTokenDTO(refresh: data.refresh)
                )
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func signUp(name: String, email: String, password: String, role: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        remoteDataSource.signUp(name: name, email: email, password: password, role: role) { [weak self] result in
            switch result {
            case .success():
                self?.remoteDataSource.login(email: email, password: password) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.localDataSource.setInitialToken(
                            access: AccessTokenDTO(access: data.access),
                            refresh: RefreshTokenDTO(refresh: data.refresh)
                        )
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getAccessToken(completion: @escaping (Result<Void, any Error>) -> Void) {
        remoteDataSource.accessGuarded { [weak self] result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure:
                self?.remoteDataSource.refreshToken(refreshToken: self?.localDataSource.getRequestToken()) { [weak self] result in
                    switch result {
                    case .success(let accessToken):
                        self?.localDataSource.setInitialToken(access: accessToken, refresh: nil)
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func logout() {
        localDataSource.removeToken()
    }

    func getRefreshToken() -> RefreshTokenDTO {
        localDataSource.getRequestToken()
    }
}
