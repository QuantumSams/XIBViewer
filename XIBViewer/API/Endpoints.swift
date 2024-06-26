import Foundation


enum Endpoints{
        
    case login (path: String = "/api/auth/login/", model: LoginModel)
    case signup(path: String = "/api/auth/register/", model: SignupModel)
    case getAccountData (path: String = "/api/users/me/")

    var request:URLRequest? {
        
        guard let url = self.url else{
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.addValues(self)
        request.httpBody = self.httpBody
        
        return request
    }
    
    private var url:URL? {
        var component = URLComponents()
        component.scheme = API_Constant.scheme
        component.host   = API_Constant.baseURL
        component.port   = API_Constant.port
        component.path = self.path
        return component.url
    }
    
    
    var path: String {
        switch self{
        case .login(path: let path, _): return path
        case .signup(path: let path, _): return path
        case .getAccountData(path: let path): return path
            
        }
    }
    
    var httpBody: Data?{
        switch self{
        case .login(path: _, model: let model):
            let json = try? JSONEncoder().encode(model)
            return json
                
        case .signup(path: _, model: let model):
            let json = try? JSONEncoder().encode(model)
            return json
            
        case .getAccountData(_):
            return nil
        }
    }
    
    var httpMethod: String{
        switch self{
        case .login: return HTTP.Methods.post.rawValue
        case .signup: return HTTP.Methods.post.rawValue
        case .getAccountData: return HTTP.Methods.get.rawValue
            
        }
    }
}
