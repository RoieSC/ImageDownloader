//
//  HTTPClient.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 10/10/2023.
//

import Foundation

protocol HTTPClient {
    func fetchData<T: Decodable>(urlString: String, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func fetchData<T: Decodable>(urlString: String,
                                 responseModel: T.Type) async -> Result<T, RequestError> {
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            case 500...599:
                return .failure(.serverError)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
