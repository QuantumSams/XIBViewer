import Foundation

enum HTTP{
    enum Methods: String{
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case patch  = "PATCH"
        case delete = "DELETE"
    }
    
    enum Headers{
        
        enum Key{
            case contentType
            case authorization
            
            var HeadersKey: String{
                switch self{
                case .contentType:
                    return "Content-Type"
                case .authorization:
                    return "Authorization"
                }
            }
        }
        
        enum Value{
            case applicationJson
            case accessToken(accessToken: String)
            
            var HeaderValues: String {
                switch self{
                case .applicationJson:
                    return "application/json"
                case .accessToken(let accessToken):
                    return "Bearer \(accessToken)"
                }
                
            }
        }
        
       
    }
}
