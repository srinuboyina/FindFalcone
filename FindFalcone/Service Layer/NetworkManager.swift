//
//  NetworkManager.swift
//  CommBankAssignmentSkeleton
//
//  Created by apple on 14/04/23.
//

import Foundation
import Combine

enum APIFailureCondition: Error {
    case invalidServerResponse
    case invalidURL
}

struct Response<T> {
    let value: T
    let response: URLResponse
}

protocol Network {
    func fetchApiData<T: Decodable>(url: URL) -> AnyPublisher<Response<T>, Error>
    func requestWithParams(url: URL, params: [String: Any]) -> AnyPublisher<[String: String], Error>
}

struct NetworkManager: Network {
    
    func fetchApiData<T: Decodable>(url: URL) -> AnyPublisher<Response<T>, Error>  {
        print("*************")
        print("Endpoint url: \(url)")
        print("*************")
        return URLSession.shared.dataTaskPublisher(for: url)
               .tryMap { result -> Response<T> in

                   guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                       print("status code for api response : \((result.response as? HTTPURLResponse)?.statusCode ?? 200)")
                       throw APIFailureCondition.invalidServerResponse
                   }

                   let decoder = JSONDecoder()
                   let value = try decoder.decode(T.self, from: result.data)
                   return Response(value: value, response: result.response)
           }
           .receive(on: RunLoop.main)
           .eraseToAnyPublisher()
    }
    
    func requestWithParams(url: URL, params: [String: Any]) -> AnyPublisher<[String: String], Error> {
        
        print("*************")
        print("Endpoint url: \(url)")
        print("*************")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if params.count > 0 {
            if let jsonData = try? JSONSerialization.data(withJSONObject: params)  {
                request.httpBody = jsonData
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> [String: String] in
                
                guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("status code for api response : \((result.response as? HTTPURLResponse)?.statusCode ?? 200)")
                    throw APIFailureCondition.invalidServerResponse
                }
                
                let decoder = JSONDecoder()
                let value = try? JSONSerialization.jsonObject(with: result.data) as? [String: String]
                return value ?? [:]
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
