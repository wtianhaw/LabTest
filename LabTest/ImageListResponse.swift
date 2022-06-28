//
//  ImageListResponse.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation

class ImageListResponse: Codable {
    
    var list: [ImageListItem]
    
    required init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var newList : [ImageListItem] = []
        
        while !container.isAtEnd {
            do {
                let decoded = try container.decode(ImageListItem.self)
                newList.append(decoded)
            } catch {
                break
            }
        }
        list = newList
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(list)
    }
    
}


struct ImageListItem: Codable {
    let id, author: String?
    let width, height: Int?
    let url : String?
    let downloadURL : String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case width = "width"
        case height = "height"
        case url = "url"
        case downloadURL = "downloadUrl"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        author = try values.decode(String.self, forKey: .author)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        url = try values.decode(String.self, forKey: .url)
        downloadURL = try values.decodeIfPresent(String.self, forKey: .downloadURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(author, forKey: .author)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(downloadURL, forKey: .downloadURL)
    }
}
