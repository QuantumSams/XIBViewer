import Foundation

extension URLRequest{
    mutating func addValues(_ endpoints: Endpoints){
        switch endpoints{
        case .login:
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, 
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            
        case.signup:
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, 
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
        }
    }
}
