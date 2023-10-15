//
//  RequestError.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 10/10/2023.
//

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case serverError
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
