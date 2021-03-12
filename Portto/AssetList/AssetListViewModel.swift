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
    
    var assets: [Asset] = [] {
        didSet {
            
        }
    }
    var onAssetsFetch: ((Error?) -> Void)?
    
    func fetchAssets() {
        guard !isLoading && !isLoadAll else {
            return
        }
        
        isLoading = true
        networkServiceProvider.request(for: OpenSeaAPI.assets(offset: assets.count)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let parser = try? JSONDecoder().decode(AssetList.self, from: response.data) else {
                    self?.isLoading = false
                    return
                }
                self?.assets.append(contentsOf: parser.assets)
                self?.onAssetsFetch?(nil)
                self?.isLoadAll = parser.assets.count < 20
            case .failure(let error):
                break
            }
            self?.isLoading = false
        }
    }
}

extension AssetListViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetList", for: indexPath) as! AssetListCollectionViewCell
        cell.asset = assets[indexPath.item]
        return cell
    }
}

extension AssetListViewModel {
    struct AssetList: Decodable {
        var assets: [Asset]
    }
}
