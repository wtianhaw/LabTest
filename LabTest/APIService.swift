//
//  APIService.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation
import Combine
import UIKit

protocol APIServiceType {
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: APIRequestType
}

final class APIService: APIServiceType {
    
    let apiLoading: ApiLoading = ApiLoading(loading: false)
    var encoding: APIEncoding = .url
    var uploadPath: String = ""
    private var baseURL: URL?
    private var baseString: String
    
    init() {
        self.baseString = Constant.BASEURL
        self.baseURL = URL(string: self.baseString)
    }
    
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: APIRequestType {
        let urlString = request.isFullUrl ? request.path : "\(baseString)\(request.path)"
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            switch self.encoding {
            case .json:
                let json = try? JSONSerialization.data(withJSONObject: request.params)
                urlRequest.httpBody = json
            default:
                break
            }
            
            urlRequest.httpMethod = request.method.rawValue
            
            self.apiLoading.loading = true
            
            let decorder = JSONDecoder()
            decorder.keyDecodingStrategy = .convertFromSnakeCase
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .map { [weak self] data, urlResponse in
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    print("json: \(json ?? "n/a")")
                    
                    self?.apiLoading.loading = false
                    if var jDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let response = urlResponse as? HTTPURLResponse {
                        jDict["code"] = response.statusCode
                        let jData = try? JSONSerialization.data(withJSONObject: jDict)
                        return jData ?? Data()
                    }
                    if let json = json, let newData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                        return newData
                    }
                    let string = data.base64EncodedString()
                    let jsonObject: [String: Any] = [
                        "image": string,
                    ]
                    do {
                        let newdata = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                        return newdata
                    } catch let convertJsonError {
                        print(convertJsonError)
                    }
                    
                    return Data() }
                .mapError { _ in APIServiceError.responseError }
                .decode(type: Request.Response.self, decoder: decorder)
                .receive(on: RunLoop.main)
                .mapError({ error in
                    print(error.localizedDescription)
                    return error
                })
            //            .retry(3)
                .eraseToAnyPublisher()
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
