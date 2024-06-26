import Foundation

extension URLRequest{
    mutating func addValues(_ endpoints: Endpoints){
        switch endpoints{
        case .login, 
                .signup:
                
            self.setValue(HTTP.Headers.Value.applicationJson.HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.HeadersKey)
            
        case .getAccountData:
            self.setValue(HTTP.Headers.Value.applicationJson.HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.HeadersKey)
            
            self.setValue(HTTP.Headers.Value.accessToken(accessToken:
                                                            TokenSingleton.getToken.getAccessToken()).HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.authorization.HeadersKey)
            print("HERE!!!!!")
        }
    }
}
