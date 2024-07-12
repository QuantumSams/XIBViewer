import Foundation

//Login request
class AuthService{
    static func login(request: URLRequest, completion: @escaping (Result<SuccessLoginResponse, Error>) -> Void){
        URLSession.shared.dataTask(with: request) { data, _, error in
            
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
            
            //case: received data - 2xx response
            if let successData = try? decoder.decode(SuccessLoginResponse.self, from: data){
                completion(.success(successData))
                return
            }
            
            //case: server error response - 4xx response
            else if let errorData = try? decoder.decode(ErrorResponse.self, from: data){
                completion(.failure(APIErrorTypes.serverError(errorData.detail)))
                return
            }
            
            //case: local server response model does not match that of server
            else {
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
            
        }.resume()
    }
}

//Sign up request
extension AuthService{
    static func signUp(request: URLRequest, completion: @escaping (Result<String, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { data, responseCode, error in
            
            //MARK: LOCAL ERROR OCCURRED - cannot send request
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
            
            
            //MARK: REQUEST SENT
            let decoder = JSONDecoder()
            
            //case: local server response model does not match that of server
            guard let responseCode = responseCode as? HTTPURLResponse else{
                completion(.failure(APIErrorTypes.unknownError("No response from server")))
                return
            }
            //case: received data - 2xx response
            if(responseCode.statusCode >= 200 && responseCode.statusCode <= 299){
                completion(.success("Sucess"))
                return
            }

            //case: server error response - 4xx response
            else if let errorData = try? decoder.decode(SignupErrorResponse.self, from: data){
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

//Refresh token request

extension AuthService{
    static func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        
        let model = RefreshTokenModel(refresh: TokenSingleton.getToken.getRequestToken())
        guard let request = Endpoints.refreshToken(model: model).request else {return}
        

        
        URLSession.shared.dataTask(with: request) { data, responseCode, error in
            
            guard let data = data else{
                if let error = error{
                    completion(.failure(APIErrorTypes.serverError(error.localizedDescription)))
                }
                else{
                    completion(.failure(APIErrorTypes.unknownError("UNKNOWN ERROR: no response from server")))
                }
                return
            }
            
            let code = responseCode as! HTTPURLResponse
            let decoder = JSONDecoder()
            
            if let successData = try? decoder.decode(RefreshTokenResponse.self, from: data){
                completion(.success(successData.access))
                return
            }
            
            else if let errorData = try? decoder.decode(ErrorResponse.self, from: data){
                completion(.failure(APIErrorTypes.serverError(errorData.detail)))
                return
            }
            
            else{
                completion(.failure(APIErrorTypes.deviceError("Cannot parse neither to data type nor error type\n Error code: \(code)")))
                return
            }
        }.resume()
    }
}
