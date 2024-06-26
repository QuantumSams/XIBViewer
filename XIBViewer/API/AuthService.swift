import Foundation

//Sending request
class AuthService{
    static func login(request: URLRequest, completion: @escaping (Result<String, Error>) -> Void){
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            //MARK: LOCAL ERROR OCCURRED
            guard let data = data else{
                //case: error response exists
                if let error = error{
                    completion(.failure(APIErrorTypes.serverError(error.localizedDescription)))
                }
                //case: no error response from sever
                else{
                    completion(.failure(APIErrorTypes.unknownError("UNKNOWN ERROR: no response from server")))
                }
                return
            }
            
            
            //MARK: NO LOCAL ERROR - RESPONSE RECEIVED
            let decoder = JSONDecoder()
            
            //case: received data
            if let successData = try? decoder.decode(SuccessLoginResponse.self, from: data){
                let token = TokenSingleton.getToken
                completion(.success(successData.access))
                token.setInitialToken(access: successData.access, refresh: successData.refresh)
                return
            }
            
            //case: server error response
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

