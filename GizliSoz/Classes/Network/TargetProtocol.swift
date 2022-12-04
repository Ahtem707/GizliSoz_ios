//
//  TargetProtocol.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

protocol Target {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var query: [String : String] { get }
    var body: Data { get }
    var sampleData: Data { get }
    
    func request<T: Codable>(_ type: T.Type, completion: @escaping RequestClosure<T>)
}

extension Target {
    func request<T: Codable>(_ type: T.Type, completion: @escaping RequestClosure<T>) {
        API.request(type, target: self, completion: completion)
    }
}
