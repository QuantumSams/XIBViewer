import Foundation


enum APIErrorTypes: Error{
    case serverError(String)
    case decodingError(String = "PARSING ERROR")
    case unknownError(String = "UNKNOWN ERROR")
}
