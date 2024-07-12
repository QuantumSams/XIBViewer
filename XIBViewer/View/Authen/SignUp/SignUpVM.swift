import Foundation

class SignUpVM {
    var email: String?
    var name: String?
    var password: String?
    var role: RoleModel?
    var roleSelectionMenu: [RoleModel]?
}

extension SignUpVM {
    private func getDataFromTableFields() -> SignupModel? {
        guard let name: String = name,
              let email: String = email,
              let password: String = password,
              let role: RoleModel = role,
              role.id != -1
        else {
            return nil
        }
        return SignupModel(
            name: name,
            email: email,
            role: role.id,
            password: password
        )
    }
    
    func requestSignUpAPI(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let signUpData = getDataFromTableFields() else {
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
        }
        
        guard let request = Endpoints.signup(model: signUpData).request else {
            completion(.failure(APIErrorTypes.unknownError("Request cannot be fullfilled - Endpoint error")))
            return
        }
        
        AuthService.signUp(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginAftersignUp(completion: @escaping ((Result<SuccessLoginResponse, Error>) -> Void)) {
        guard let email = email,
              let password = password
        else {
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
        }
        let loginData = LoginModel(email: email, password: password)
            
        guard let request = Endpoints.login(model: loginData).request else {
            completion(.failure(APIErrorTypes.unknownError("Request cannot be fullfilled - Endpoint error")))
            return
        }
            
        AuthService.login(request: request) { result in
            switch result {
            case .success(let tokenData):
                completion(.success(tokenData))
            case .failure(let error):
                guard let error = error as? APIErrorTypes else { return }
                completion(.failure(error))
            }
        }
    }
        
    func requestRoleAPI(completion: @escaping ((Result<Void, Error>) -> Void)) {
        RoleService.getRole { [weak self] result in
            switch result {
            case .success(let data):
                self?.roleSelectionMenu = data.results
                completion(.success(()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
    
