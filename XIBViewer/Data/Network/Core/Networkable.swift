import Foundation

protocol Networkable {
    func sendRequest<T: Decodable>(urlRequest: URLRequest,
                                   resultHandler: @escaping (Result<T, APIErrorTypes>) -> Void)

    func sendRequest(urlRequest: URLRequest,
                     resultHandler: @escaping (Result<Void, APIErrorTypes>) -> Void)
}

final class NetworkService: Networkable {
    private var session: URLSession {
        let sessionConfig = URLSessionConfiguration.default
        // time limit for addtional data to arrive
        sessionConfig.timeoutIntervalForRequest = 5

        // total time limit for an API call
        sessionConfig.timeoutIntervalForResource = 10

        return URLSession(configuration: sessionConfig)
    }

    public func sendRequest<T: Decodable>(urlRequest: URLRequest,
                                          resultHandler: @escaping (Result<T, APIErrorTypes>) -> Void)
    {
        let urlTask = session.dataTask(with: urlRequest) { data, response, error in

            if let error = error {
                resultHandler(.failure(APIErrorTypes.deviceError(error.localizedDescription)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                resultHandler(.failure(APIErrorTypes.noResponse()))
                return
            }

            guard let data = data else {
                resultHandler(.failure(APIErrorTypes.unknownError()))
                return
            }

            if 200...299 ~= response.statusCode {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    resultHandler(.success(decodedResponse))
                } catch {
                    print(error)
                    resultHandler(.failure(APIErrorTypes.decodingError()))
                }
                return
            } else if response.statusCode == 401 {
                resultHandler(.failure(APIErrorTypes.unauthorized))
            } else {
                let dataString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? "Unknown Error"

                print(dataString)
                resultHandler(.failure(APIErrorTypes.unknownError("Status code out of range \n \(dataString)")))
            }
        }
        urlTask.resume()
    }
}

extension NetworkService {
    public func sendRequest(urlRequest: URLRequest,
                            resultHandler: @escaping (Result<Void, APIErrorTypes>) -> Void)
    {
        let urlTask = session.dataTask(with: urlRequest) { data, response, error in

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

            } else if response.statusCode == 401 {
                resultHandler(.failure(APIErrorTypes.unauthorized))
            } else {
                guard let data = data else {
                    resultHandler(.failure(APIErrorTypes.unknownError()))
                    return
                }

                let dataString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? "Unknown Error"

                print(dataString)
                resultHandler(.failure(APIErrorTypes.unknownError("Status code out of range \n \(dataString)")))
            }
        }
        urlTask.resume()
    }
}
