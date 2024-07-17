import Foundation

final class AccountRepositoryImp {
    private let remoteDataSource: AccountRemoteDataSource = AccountRemoteDataSourceImp()
}

extension AccountRepositoryImp: AccountRepository {
    func getOneUser(completion: @escaping (Result<AccountModel, any Error>) -> Void) {
        remoteDataSource.getOneUser(completion: completion)
    }

    func editOneUser(for data: EditUserDTO, completion: @escaping (Result<AccountModel, Error>) -> Void) {
        remoteDataSource.editOneUser(for: data, completion: completion)
    }
}
