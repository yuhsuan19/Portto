//
//  AssetListViewModel.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import Foundation

class AssetListViewModel: BasedViewModel {
    
    var offset: Int = 0
    var assets: [Asset] = []
    
    func fetchAssets() {
        networkServiceProvider.request(for: OpenSeaAPI.assets(offset: offset)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let parser = try? JSONDecoder().decode(AssetList.self, from: response.data) else {
                    return
                }
                self?.assets.append(contentsOf: parser.assets)
                
            case .failure(let error):
                break
            }
        }
    }
}

extension AssetListViewModel {
    struct AssetList: Decodable {
        var assets: [Asset]
    }
}
