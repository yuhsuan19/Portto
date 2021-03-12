//
//  OpenSeaAPI.swift
//  Portto
//
//  Created by CHI on 2021/3/11.
//

import Foundation

enum OpenSeaAPI {
    case assets(offset: Int = 0, perPageAmount: Int = 20)
}

extension OpenSeaAPI: NetworkService {
    var baseURL: URL {
        return URL(string: "https://api.opensea.io/api/v1/")!
    }
    
    var path: String {
        switch self {
        case .assets:
            return "assets"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .assets:
            return .get
        }
    }
    
    var httpHeaders: [String : String]? {
        return nil
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .assets(let offset, let perPageAmount):
            return [
                "owner": "0x960DE9907A2e2f5363646d48D7FB675Cd2892e91",
                "format": "json",
                "limit": perPageAmount,
                "offset": offset
            ]
        }
    }
    
    var encoding: Encoding? {
        switch self {
        case .assets:
            return .url
        }
    }
    
    var timeout: TimeInterval {
        return 10
    }
    
    var uploadContent: UploadContent? {
        return nil
    }
}
 
