import Foundation


class AccountVM{
    var adminUser: UserModel?
    private let userRepo: AccountRepository = AccountRepositoryImp()
    private let authRepo: AuthenticationRepository = AuthenticationRepositoryImp()
    
    func fetchAdminData(completion: @escaping (Result<Void, Error>) -> Void){
        
        userRepo.getOneUser { [weak self] result in
            switch result{
            case .success(let adminUser):
                self?.adminUser = adminUser
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
                self?.revokeAuthen()
            }
        }
    }
    
    func revokeAuthen(){
        authRepo.logout()
    }
}


