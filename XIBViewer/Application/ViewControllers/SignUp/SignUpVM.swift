import Foundation

class SignUpVM {
    var email: String?
    var name: String?
    var password: String?
    var role: RoleModel?
    var roleSelectionMenu: [RoleModel]?
    
    private let roleRepo: RoleListRepository = RoleListRepositoryImp()
    private let authRepo: AuthenticationRepository = AuthenticationRepositoryImp()
}

extension SignUpVM {
    func requestSignUpAPI(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let name: String = name,
              let email: String = email,
              let password: String = password,
              let role: RoleModel = role,
              role.id != -1
        else {
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.authRepo.signUp(name: name,
                                  email: email,
                                  password: password,
                                  role: role.id)
            { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
        
    func requestRoleAPI(completion: @escaping ((Result<Void, Error>) -> Void)) {
        roleRepo.getRoleList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.roleSelectionMenu = data
                    completion(.success(()))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func requestRefreshToken(transition: Bool = true, completion: @escaping (Result<Void, Error>) -> Void) {
        authRepo.getAccessToken { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
    
