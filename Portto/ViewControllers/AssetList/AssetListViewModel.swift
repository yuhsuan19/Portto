//
//  AssetListViewModel.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import Foundation
import UIKit

class AssetListViewModel: BasedViewModel {
    
    // MARK: Fetch assets
    var isLoadAll: Bool = false

    let perPageAmount = 20

    var assets: [Asset] = []
    var onAssetsFetch: ((Error?) -> Void)?
    
    func fetchAssets() {
        guard !isLoading && !isLoadAll else {
            return
        }
        
        isLoading = true
        networkServiceProvider.request(for: OpenSeaAPI.assets(offset: assets.count, perPageAmount: perPageAmount)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let parser = try? JSONDecoder().decode(AssetList.self, from: response.data) else {
                    self?.isLoading = false
                    self?.onAssetsFetch?(AppError.networkFailed)
                    return
                }
                self?.assets.append(contentsOf: parser.assets)
                self?.onAssetsFetch?(nil)
                self?.isLoadAll = parser.assets.count < (self?.perPageAmount ?? 20)
            case .failure(let error):
                self?.onAssetsFetch?(error)
            }
            self?.isLoading = false
        }
    }
}

extension AssetListViewModel {
    struct AssetList: Decodable {
        var assets: [Asset]
    }
}
