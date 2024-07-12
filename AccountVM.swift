import Foundation


class AccountVM{
    var adminUser: UserModel?
    
    func fetchAdminData(completion: @escaping (Result<Void, Error>) -> Void){
        
        AccountService.getAccount { [weak self] result in
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
        TokenSingleton.getToken.removeToken()
    }
}


