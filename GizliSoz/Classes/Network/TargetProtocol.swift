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
    var headers: [String : Any] { get }
    var query: [String : Any] { get }
    var body: Data { get }
    var sampleData: Data { get }
    
    func request<T: Codable>(_ type: T.Type, completion: @escaping RequestClosure<T>)
}

extension Target {
    
    func request<T: Codable>(_ type: T.Type, completion: @escaping RequestClosure<T>) {
        API(self, dispatchGroup: nil).request(type, completion: completion)
    }
    
    func async(_ dispatchGroup: DispatchGroup) -> API {
        return API(self, dispatchGroup: dispatchGroup)
    }
    
    // TODO: - REFACTOR Не работает, переделать или выпилить
    func sync(_ runStack: RunStack) -> API {
        return API(self, runStack: runStack)
    }
}
