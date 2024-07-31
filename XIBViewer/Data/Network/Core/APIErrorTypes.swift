import Foundation

enum APIErrorTypes: Error {
    case deviceError(String)
    case serverError(String)
    case decodingError(String = "PARSING ERROR")
    case unknownError(String = "UNKNOWN ERROR")
    case dataIsMissing(String = "Not all data has been filled, please try again")
    case unauthorized
    case invalidURL(String = "URL is invalid")
    case noResponse(String = "No response from server")
}
