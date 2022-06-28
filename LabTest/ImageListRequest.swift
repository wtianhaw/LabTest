//
//  ImageListRequest.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation

class ImageListRequest: APIRequestType {
    
    var isFullUrl: Bool = false
    
    typealias Response = ImageListResponse
    
    var path: String = "/v2/list"

    var params: [String: Any] = [:]
    
    var method: APIMethod = .get
}
