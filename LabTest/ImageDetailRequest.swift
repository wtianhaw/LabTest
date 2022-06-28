//
//  ImageDetailRequest.swift
//  LabTest
//
//  Created by Wong Tian Haw on 27/06/2022.
//

import Foundation

class ImageDetailRequest: APIRequestType {
    
    var isFullUrl: Bool = true
    
    typealias Response = ImageDetailResponse
    
    var path: String = "/id"

    var params: [String: Any] = [:]
    
    var method: APIMethod = .get
}
