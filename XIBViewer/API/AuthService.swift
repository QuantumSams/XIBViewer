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
                print("log in error code:\n")
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
            
        }.resume()
    }
}

extension AuthService{
    static func signUp(request: URLRequest, completion: @escaping (Result<String, Error>) -> Void){
        
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
            
            print(responseCode)
            
            
            //case: received data - 2xx response
            if(responseCode.statusCode >= 200 && responseCode.statusCode <= 299){
                completion(.success("Sucess"))
                return
            }

            //case: server error response - 4xx response
            else if let errorData = try? decoder.decode(SignupErrorResponse.self, from: data){
                let returnString = String.getOneString(from: [errorData.email, errorData.role], defaut: "No error description was given")
                
                print("HERE2")

                
                completion(.failure(APIErrorTypes.serverError(returnString)))
                return
            }
            
            else {
                print("sign up error code:\n")
                print(responseCode)
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
        }.resume()
    }
}
