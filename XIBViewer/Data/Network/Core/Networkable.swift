import Foundation

protocol Networkable {
    func sendRequest<T: Decodable>(urlRequest: URLRequest,
                                          resultHandler: @escaping (Result<T, APIErrorTypes>) -> Void)
}

class NetworkService {
    
    public func sendRequest<T: Decodable>(urlRequest: URLRequest,
                                          resultHandler: @escaping (Result<T, APIErrorTypes>) -> Void) {
        
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            guard error == nil else {
                resultHandler(.failure(.invalidURL()))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                resultHandler(.failure(.noResponse()))
                return
            }

            if 200...299 ~= response.statusCode {
                guard let data = data else {
                    resultHandler(.failure(.unknownError()))
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    resultHandler(.success(decodedResponse))
                } catch {
                    print(error)
                    resultHandler(.failure(.decodingError()))
                }
            } else {
                resultHandler(.failure(.unknownError("Status code out of range")))
            }
        }
        urlTask.resume()
    }
    
}

extension NetworkService{
    public func sendRequest(urlRequest: URLRequest,
                                          resultHandler: @escaping (Result<Void, APIErrorTypes>) -> Void) {
        
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            guard error == nil else {
                resultHandler(.failure(.invalidURL()))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                resultHandler(.failure(.noResponse()))
                return
            }

            if 200...299 ~= response.statusCode {
                resultHandler(.success(()))
                
            } else {
                resultHandler(.failure(.unknownError("Status code out of range")))
            }
        }
        urlTask.resume()
    }
}
