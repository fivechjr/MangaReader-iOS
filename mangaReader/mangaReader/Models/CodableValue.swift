//
//  CodableValue.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/5.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

enum CodableValue: Codable {
    case int(Int)
    case double(Double)
    case bool(Bool)
    case string(String)
    
    enum CodingKeys: CodingKey {
        case int
        case double
        case bool
        case string
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .int(let value):
            try container.encode(value, forKey: .int)
        case .double(let value):
            try container.encode(value, forKey: .double)
        case .bool(let value):
            try container.encode(value, forKey: .bool)
        case .string(let value):
            try container.encode(value, forKey: .string)
        }
    }
    
    init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(value)
        } else if let value = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(value)
        } else if let value = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(value)
        } else {
            throw ParsingError.unsupportedType
        }
    }
    
    enum ParsingError: Error {
        case unsupportedType
    }
}
