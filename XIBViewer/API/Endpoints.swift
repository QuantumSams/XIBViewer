import Foundation


enum Endpoints{
    
    case login          (path: String = "/api/auth/login/", model: LoginModel)
    case signup         (path: String = "/api/auth/register/", model: SignupModel)
    case getAccountData (path: String = "/api/users/me/")

    case getRole        (path: String = "/api/roles/")
    case refreshToken   (path: String = "/api/auth/refresh-token/", model: RefreshTokenModel)
    case editUser       (path: String = "/api/users/", model: PUTMethodUserModel, id: Int)
    case getUserList    (path: String = "/api/users/", limit: Int = 10, offset: Int = 0)
    
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
        component.queryItems = self.queryItem
        print(component.url!)
        return component.url
    }
    
    var path: String {
        switch self{
        case .login(path: let path, _):         return path
        case .signup(path: let path, _):        return path
        case .getAccountData(path: let path):   return path
        case .getRole(path: let path):          return path
        case .refreshToken(path: let path, _):  return path
        case .editUser(path: let path, model: _, id: let id): return path + String(id) + "/"
        case .getUserList(path: let path, _, _): return path
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
        case .getRole(_):
            return nil
        case .refreshToken(path: _, model: let model):
            let json = try? JSONEncoder().encode(model)
            return json
            
        case .editUser(path: _, model: let model, id: _):
            let json = try? JSONEncoder().encode(model)
            return json
        case .getUserList(_, _, _):
            return nil
        }
    }
    
    var queryItem: [URLQueryItem]?{
        switch self{
        case .getUserList(_, let limit, let offset):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            
            ]

        
        default: return nil
        }
    }
    
    var httpMethod: String{
        switch self{
        case .login: return HTTP.Methods.post.rawValue
        case .signup: return HTTP.Methods.post.rawValue
        case .getAccountData: return HTTP.Methods.get.rawValue
            
        case .getRole:
            return HTTP.Methods.get.rawValue
        case .refreshToken:
            return HTTP.Methods.post.rawValue
        case .editUser:
            return HTTP.Methods.put.rawValue
        case .getUserList:
            return HTTP.Methods.get.rawValue
        }
    }
}
