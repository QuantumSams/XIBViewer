import Foundation


enum Endpoints{
    
    case login          (path: String = "/api/auth/login/", model: LoginDTO)
    case signup         (path: String = "/api/auth/register/", model: SignUpDTO)
    case getAccountData (path: String = "/api/users/me/")
    case getRole        (path: String = "/api/roles/")
    case refreshToken   (path: String = "/api/auth/refresh-token/", model: RefreshTokenDTO)
    case editUser       (path: String = "/api/users/", model: EditUserDataDTO, id: Int)
    case deleteUser     (path: String = "/api/users/", id: Int)
    case getUserList    (path: String = "/api/users/", limit: Int = 10, offset: Int = 0)
    
    case loadMoreUserList(fullPath: URL)
    
    
}

extension Endpoints{
    var request:URLRequest? {
        
        guard let url = self.url else{
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod      = self.httpMethod
        request.httpBody        = self.httpBody
        request.addValues(self)
        print(request)
        return request
    }
    
    private var url:URL? {
        switch self{
        case .loadMoreUserList(fullPath: let fullPath): return fullPath
            
        default:
            var component = URLComponents()
            component.scheme        = API_Constant.scheme
            component.host          = API_Constant.baseURL
            component.port          = API_Constant.port
            component.path          = self.path
            component.queryItems    = self.queryItem
            return component.url
        }
        
        
        
    }
    
    var path: String {
        switch self{
        case .login(path: let path, _):                         return path
        case .signup(path: let path, _):                        return path
        case .getAccountData(path: let path):                   return path
        case .getRole(path: let path):                          return path
        case .refreshToken(path: let path, _):                  return path
        case .editUser(path: let path, model: _, id: let id):   return path + String(id) + "/"
        case .deleteUser(path: let path, id: let id):           return path + String(id) + "/"
        case .getUserList(path: let path, _, _):                return path
        case .loadMoreUserList:                                 return ""
        }
    }
    
    var httpBody: Data?{
        switch self{
        case .login(path: _, model: let model):
            return try? JSONEncoder().encode(model)

        case .signup(path: _, model: let model):
           return try? JSONEncoder().encode(model)
            
        case .getAccountData(_):
            return nil
            
        case .getRole(_):
            
            return nil
        case .refreshToken(path: _, model: let model):
            return try? JSONEncoder().encode(model)
            
        case .editUser(path: _, model: let model, id: _):
            return try? JSONEncoder().encode(model)
            
        case .getUserList:
            return nil
            
        case .deleteUser:
            return nil
        case .loadMoreUserList:
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
        case .login:            return HTTP.Methods.post.rawValue
        case .signup:           return HTTP.Methods.post.rawValue
        case .getAccountData:   return HTTP.Methods.get.rawValue
        case .getRole:          return HTTP.Methods.get.rawValue
        case .refreshToken:     return HTTP.Methods.post.rawValue
        case .editUser:         return HTTP.Methods.put.rawValue
        case .deleteUser:       return HTTP.Methods.delete.rawValue
        case .getUserList:      return HTTP.Methods.get.rawValue
        case .loadMoreUserList: return HTTP.Methods.get.rawValue
        }
    }
}
