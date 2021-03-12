//
//  Asset.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import Foundation

struct Asset: Decodable {
    let name: String?
    let description: String?
    
    let image_url: URL?
    let image_thumbnail_url: URL?
    let permalink: URL?
    
    let collection: Collection?
    
}

extension Asset {
    struct Collection: Decodable {
        let name: String?
    }
}
