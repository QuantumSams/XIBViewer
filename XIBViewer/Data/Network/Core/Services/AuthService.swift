import Foundation

// Login request
class AuthService {
    private static let authenRepo: AuthenticationRepository = AuthenticationRepositoryImp()
    
    static func login(request: URLRequest, completion: @escaping (Result<SuccessLoginResponseDTO, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            // MARK: LOCAL ERROR OCCURRED

            guard let data = data else {
                // case: error response exists
                if let error = error {
                    completion(.failure(APIErrorTypes.deviceError(error.localizedDescription)))
                }
                // case: no error response from sever
                else {
                    completion(.failure(APIErrorTypes.unknownError("UNKNOWN ERROR: no response from server")))
                }
                return
            }
            
            // MARK: NO LOCAL ERROR - RESPONSE RECEIVED

            let decoder = JSONDecoder()
            
            // case: received data - 2xx response
            if let successData = try? decoder.decode(SuccessLoginResponseDTO.self, from: data) {
                completion(.success(successData))
                return
            }
            
            // case: server error response - 4xx response
            else if let errorData = try? decoder.decode(ErrorResponseDTO.self, from: data) {
                completion(.failure(APIErrorTypes.serverError(errorData.detail)))
                return
            }
            
            // case: local server response model does not match that of server
            else {
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
            
        }.resume()
    }
}

// Sign up request
extension AuthService {
    static func signUp(request: URLRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, responseCode, error in
            
            // MARK: LOCAL ERROR OCCURRED - cannot send request

            guard let data = data else {
                // case: error response exists
                if let error = error {
                    completion(.failure(APIErrorTypes.deviceError(error.localizedDescription)))
                }
                // case: no error response from sever
                else {
                    completion(.failure(APIErrorTypes.unknownError("UNKNOWN ERROR: no response from server")))
                }
                return
            }
            
            // MARK: REQUEST SENT

            let decoder = JSONDecoder()
            
            // case: local server response model does not match that of server
            guard let responseCode = responseCode as? HTTPURLResponse else {
                completion(.failure(APIErrorTypes.unknownError("No response from server")))
                return
            }
            // case: received data - 2xx response
            if responseCode.statusCode >= 200, responseCode.statusCode <= 299 {
                completion(.success(()))
                return
            }

            // case: server error response - 4xx response
            else if let errorData = try? decoder.decode(SignupErrorResponseDTO.self, from: data) {
                let errorString = errorData.email?.first?.value.capitalized ?? "No error response was given"
                completion(.failure(APIErrorTypes.serverError(errorString)))
                return
            }
            
            else {
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
        }.resume()
    }
}

// Refresh token request

extension AuthService {
    static func refreshToken(completion: @escaping (Result<AccessTokenDTO, Error>) -> Void) {
        let model = authenRepo.getRefreshToken()
        
        guard let request = Endpoints.refreshToken(model: model).request else {
            completion(.failure(APIErrorTypes.unknownError("Cannot create request from endpoint - AuthService - refreshToken")))
            
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, responseCode, error in
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(APIErrorTypes.serverError(error.localizedDescription)))
                }
                else {
                    completion(.failure(APIErrorTypes.unknownError("UNKNOWN ERROR: no response from server")))
                }
                return
            }
            
            let code = responseCode as! HTTPURLResponse
            let decoder = JSONDecoder()
            
            if let successData = try? decoder.decode(AccessTokenDTO.self, from: data) {
                completion(.success(successData))
                return
            }
            
            else if let errorData = try? decoder.decode(ErrorResponseDTO.self, from: data) {
                if code.statusCode == 401{
                    completion(.failure(APIErrorTypes.unauthorized))
                    return
                }
                completion(.failure(APIErrorTypes.serverError(errorData.detail)))
                return
            }
            
            else {
                let dataString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                
                completion(.failure(APIErrorTypes.deviceError("Cannot parse neither to data type nor error type\n Error code: \(code.statusCode) \(dataString)")))
                return
            }
        }.resume()
    }
}
extension AuthService{
    static func accessGuarded(completion: @escaping (Result<Void, Error>) -> Void){
        
        guard let request = Endpoints.accessGuarded().request else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            //MARK: LOCAL ERROR OCCURRED
            guard let data = data else{
                //case: error response exists
                if let error = error{
                    completion(.failure(APIErrorTypes.deviceError(error.localizedDescription)))
                }
                //case: no error response from sever
                else{
                    completion(.failure(APIErrorTypes.unknownError("UNKNOWN ERROR: no response from server")))
                }
                return
            }
            
            
            //MARK: NO LOCAL ERROR - RESPONSE RECEIVED
            let decoder = JSONDecoder()
            guard let response = response as? HTTPURLResponse else{
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
            
            //case: received data
            if 200...299 ~= response.statusCode{
                completion(.success(()))
                return
            }
            
            //case: server error response
            else if let errorData = try? decoder.decode(ErrorResponseDTO.self, from: data){
                completion(.failure(APIErrorTypes.serverError(errorData.detail)))
                return
            }
            
        }.resume()
    }
}
