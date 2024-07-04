import Foundation

class RoleService{
    static func getRole(completion: @escaping (Result<RoleResponseModel, Error>) -> Void){
        
        
        guard let request = Endpoints.getRole().request else {return}
        
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
            
            //case: received data
            
            if let roleData = try? decoder.decode(RoleResponseModel.self, from: data){
                completion(.success(roleData))
                return
            }
            
            //case: server error response
            else if let errorData = try? decoder.decode(ErrorResponse.self, from: data){
                completion(.failure(APIErrorTypes.serverError(errorData.detail)))
                return
            }
            
            //case: local server response model does not match that of server's
            else {
                completion(.failure(APIErrorTypes.decodingError()))
                return
            }
            
        }.resume()
    }
}


