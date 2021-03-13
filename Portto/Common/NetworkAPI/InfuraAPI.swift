//
//  InfuraAPI.swift
//  Portto
//
//  Created by CHI on 2021/3/14.
//

import Foundation

enum InfuraAPI {
    case getBalance
}

extension InfuraAPI: NetworkService {
    var baseURL: URL {
        return URL(string: "https://mainnet.infura.io/v3/")!
    }
    
    var path: String {
        return "0f4c28c65af942219e3da6aa3b22783c"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var httpHeaders: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .getBalance:
            return [
                "jsonrpc": "2.0",
                "method": "eth_getBalance",
                "params": ["0x960DE9907A2e2f5363646d48D7FB675Cd2892e91", "latest"],
                "id": 1
            ]
        }
    }
    
    var encoding: Encoding? {
        .json
    }
    
    var timeout: TimeInterval {
        15
    }
    
    var uploadContent: UploadContent? {
        return nil
    }
}
