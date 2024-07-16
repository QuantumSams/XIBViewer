import Foundation


protocol AuthenticationLocalDataSource{
    func setInitialToken(access: AccessTokenDTO, refresh: RefreshTokenDTO?)
    func getAccessToken() -> AccessTokenDTO
    func getRequestToken() -> RefreshTokenDTO
    func removeToken()
}

class AuthenticationLocalDataSourceImp : AuthenticationLocalDataSource{
    
  
    static let getToken = AuthenticationLocalDataSourceImp()
    private let storage = UserDefaults.standard
}


extension AuthenticationLocalDataSourceImp{
    func setInitialToken(access: AccessTokenDTO, refresh: RefreshTokenDTO? = nil){
        storage.set(access.access, forKey: "AccessTK")
        
        if let refresh = refresh{
            storage.set(refresh.refresh, forKey: "RefreshTK")
        }
        storage.synchronize()
    }
    
    func getAccessToken() -> AccessTokenDTO{
        return AccessTokenDTO(access: storage.string(forKey: "AccessTK") ?? ".")
    }
    
    func getRequestToken() -> RefreshTokenDTO{
        return RefreshTokenDTO(refresh: storage.string(forKey: "RefreshTK") ?? ".")
    }
    
    func removeToken(){
        
        storage.removeObject(forKey: "AccessTK")
        storage.removeObject(forKey: "RefreshTK")
        
        storage.synchronize()
    }
}
