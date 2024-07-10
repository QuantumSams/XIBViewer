import Foundation

extension URLRequest{
    mutating func addValues(_ endpoints: Endpoints){
        switch endpoints{
<<<<<<< HEAD
        case .login, .signup, .refreshToken, .editUser:
||||||| 803fb5e
        case .login, 
                .signup:
                
=======
        case .login, .signup, .refreshToken:
>>>>>>> feat_Auth_API
            self.setValue(HTTP.Headers.Value.applicationJson.HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.HeadersKey)
            
        case .getAccountData:
            self.setValue(HTTP.Headers.Value.applicationJson.HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.HeadersKey)
            
            self.setValue(HTTP.Headers.Value.accessToken(accessToken:
                                                            TokenSingleton.getToken.getAccessToken()).HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.authorization.HeadersKey)
        case .getRole:
            self.setValue(HTTP.Headers.Value.applicationJson.HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.HeadersKey)
        }
    }
}
