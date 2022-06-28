//
//  BaseResponse.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation

class BaseResponse : Codable {

    let status: Bool?
    let code: Int?
    let msg: String?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case code = "code"
        case msg = "message"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        msg = try? values.decodeIfPresent(String.self, forKey: .msg)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(status, forKey: .status)
        try? container.encodeIfPresent(code, forKey: .code)
        try? container.encodeIfPresent(msg, forKey: .msg)
    }

}
