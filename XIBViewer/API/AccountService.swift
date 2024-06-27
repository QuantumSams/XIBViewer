import Foundation

class AccountService{
    static func getAccount(completion: @escaping (Result<UserModel, Error>) -> Void){
        
        
        guard let request = Endpoints.getAccountData().request else {return}
        
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
            
            //case: received data
            if let accountData = try? decoder.decode(UserModel.self, from: data){
                completion(.success(accountData))
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


