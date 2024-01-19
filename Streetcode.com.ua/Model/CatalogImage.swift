//
//  CatalogImageModel.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import Foundation

// MARK: - CatalogImageModel
struct CatalogImage: Codable, DataDecodable {
    let id: Int
    let blobName, base64, mimeType: String
    let imageDetails: ImageDetails
}

// MARK: - ImageDetails
struct ImageDetails: Codable {
    let id: Int
    let title: String?
    let alt: String
    let imageID: Int

    enum CodingKeys: String, CodingKey {
        case id, title, alt
        case imageID = "imageId"
    }
}
