import Foundation

enum HTTP{
    enum Methods: String{
        case get = "GET"
        case post = "POST"
    }
    
    enum Headers{
        
        enum Key: String{
            case contentType = "Content-Type"
        }
        
        enum Value: String{
            case applicationJson = "application/json"
        }
        
    }
}
