//
//  CatalogPreviewModel.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import Foundation

struct CatalogPerson: Codable, Identifiable, DataDecodable {
    let id: Int
    let title, url, alias: String
    let imageID: Int

    enum CodingKeys: String, CodingKey {
        case id, title, url, alias
        case imageID = "imageId"
    }
    
    static let mockData = CatalogPerson(id: 438,
                                        title: "Роман Рáтушний «Сенека»",
                                        url: "roman-ratushnyi-seneka",
                                        alias: "Активіст, журналіст, доброволець",
                                        imageID: 2136)
}

