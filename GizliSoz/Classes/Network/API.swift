//
//  API.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import Foundation

typealias RequestClosure<T> = (Result<T, Error>) -> Void

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

final class API {
    
    private static let isMock: Bool = false
    
    private let target: Target
    private let dispatchGroup: DispatchGroup?
    private let runStack: RunStack?

    init(_ target: Target,
         dispatchGroup: DispatchGroup? = nil,
         runStack: RunStack? = nil) {
        self.target = target
        self.dispatchGroup = dispatchGroup
        self.runStack = runStack
    }

    func request<T: Codable>(_ type: T.Type, completion: @escaping RequestClosure<T>) {
        if runStack != nil {
            runStack?.add {
                API.variableRequest(type, target: self.target) { result in
                    completion(result)
                    self.runStack?.next()
                }
            }
        } else {
            dispatchGroup?.enter()
            API.variableRequest(type, target: target) { result in
                completion(result)
                self.dispatchGroup?.leave()
            }
        }
    }
    
    private static func variableRequest<T: Codable>(
        _ type: T.Type,
        target: Target,
        completion: @escaping RequestClosure<T>
    ) {
        if isMock  {
            API.sampleData(target: target, completion: completion)
        } else {
            let request = API.makeRequest(target)
            guard let request = request else {
                completion(.failure(AppError.urlMakeFailed))
                return
            }
            API.requestExecute(request: request, completion: completion)
        }
    }
    
    private static func makeRequest(_ target: Target) -> URLRequest? {
        var urlString = BuildConfig.baseUrl
        urlString.append(target.path)
        if !target.query.isEmpty {
            urlString.append("?")
            target.query.forEach { key, value in
                urlString.append(key + "=" + "\(value)" + "&")
            }
            urlString.removeLast()
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.httpBody = target.body
        target.headers.forEach { key, value in
            request.addValue("\(value)", forHTTPHeaderField: key)
        }
        return request
    }
    
    private static func sampleData<T: Codable>(target: Target, completion: @escaping RequestClosure<T>) {
        API.logger(target.path, target.sampleData, isMock: true)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let rawResponse = try decoder.decode(T.self, from: target.sampleData)
            completion(.success(rawResponse))
        } catch {
            completion(.failure(error as NSError))
        }
    }
    
    private static func requestExecute<T: Codable>(request: URLRequest, completion: @escaping RequestClosure<T>) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            API.logger(response?.url?.absoluteString, data)
            if let errorRequest = error { completion(.failure(errorRequest)); return }
            
            guard let data = data else { completion(.failure(AppError.contentError)); return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let apiResponse = try decoder.decode(ApiResponse.self, from: data)
                if apiResponse.result == 0 {
                    let rawResponse = try decoder.decode(T.self, from: data)
                    completion(.success(rawResponse))
                    return
                } else {
                    completion(.failure(AppError.serverError))
                    return
                }
            } catch {
                completion(.failure(error as NSError))
            }
        }.resume()
    }
    
    private static func logger(_ path: String?, _ data: Data?, isMock: Bool = false) {
        guard let path = path,
              let data = data
        else { return }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject>
        let prettyJson = data.prettyJson ?? NSString(string: String(describing: json))
        
        let logString = "\n☄️☄️☄️ /\(path)\n" + (prettyJson as String) + "\n" + "☄️☄️☄️\n"
        
        if isMock {
            AppLogger.log(.api_mock, logString)
        } else {
            AppLogger.log(.api, logString)
        }
    }
}
