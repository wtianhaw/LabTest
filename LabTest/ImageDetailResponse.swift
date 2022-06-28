//
//  ImageDetailResponse.swift
//  LabTest
//
//  Created by Wong Tian Haw on 27/06/2022.
//

import Foundation

class ImageDetailResponse: Codable {
    
    var data: String?
    
    private enum CodingKeys: String, CodingKey {
        case data = "image"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode(String.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
    
}
