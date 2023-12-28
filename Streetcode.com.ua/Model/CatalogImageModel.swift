//
//  CatalogImageModel.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import Foundation

// MARK: - CatalogImageModel
struct CatalogImageModel: Codable, DataDecodable {
    let id: Int
    let blobName, base64, mimeType: String
    let imageDetails: ImageDetails
}

// MARK: - ImageDetails
struct ImageDetails: Codable {
    let id: Int
    let title: JSONNull?
    let alt: String
    let imageID: Int

    enum CodingKeys: String, CodingKey {
        case id, title, alt
        case imageID = "imageId"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
