import Foundation

//Sending request
class AuthService{
    static func login(request: URLRequest, completion: @escaping (Result<String, Error>) -> Void){
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
                
                let token = TokenSingleton.getToken
                completion(.success(successData.access))
                token.setInitialToken(access: successData.access, refresh: successData.refresh)
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

extension AuthService{
    static func signUp(request: URLRequest, completion: @escaping (Result<SignupResponse, Error>) -> Void){
        
        URLSession.shared.dataTask(with: request) { data, errorCode, error in
            
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
            if let signUpData = try? decoder.decode(SignupResponse.self, from: data){
                completion(.success(signUpData))
                return
            }
            
            //case: server error response - 4xx response
            else if let errorData = try? decoder.decode(ErrorResponse.self, from: data){
                completion(.failure(APIErrorTypes.serverError(errorData.detail)))
                return
            }
            
            //case: local server response model does not match that of server
            else {
                print(errorCode)
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
        }.resume()
    }
}

