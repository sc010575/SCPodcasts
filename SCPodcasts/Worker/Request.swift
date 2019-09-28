//
//  Request.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 28/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation

protocol Requestable {
    func urlRequest() -> URLRequest
}

extension URLRequest: Requestable {
    func urlRequest() -> URLRequest { return self }
}

struct Request: Requestable {
    let baseUrl: URL
    let type: String
    let method: String
    
    init(_ baseURL: URL, type: String, method: String = "GET") {
        self.baseUrl = baseURL
        self.type = type
        self.method = method
    }
    
    func urlRequest() -> URLRequest {
        let finalUrl = baseUrl.appendingPathComponent(type)
        var request = URLRequest(url: finalUrl)
        request.httpMethod = method
        return request
    }
    
}
