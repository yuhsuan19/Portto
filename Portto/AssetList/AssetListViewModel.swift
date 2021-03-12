//
//  AssetListViewModel.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import Foundation

class AssetListViewModel: BasedViewModel {
    
    var offset: Int = 0
    
    func fetchAssets() {
        networkServiceProvider.request(for: OpenSeaAPI.assets(offset: offset)) { (result) in
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                break
            }
        }
    }
}
