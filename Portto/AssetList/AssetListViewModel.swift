//
//  AssetListViewModel.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import Foundation
import UIKit

class AssetListViewModel: BasedViewModel {
    
    var offset: Int = 0
    var assets: [Asset] = [] {
        didSet {
            
        }
    }
    
    var onAssetsFetch: ((Error?) -> Void)?
    
    func fetchAssets() {
        networkServiceProvider.request(for: OpenSeaAPI.assets(offset: offset)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let parser = try? JSONDecoder().decode(AssetList.self, from: response.data) else {
                    return
                }
                self?.assets.append(contentsOf: parser.assets)
                self?.onAssetsFetch?(nil)
            case .failure(let error):
                break
            }
        }
    }
}

extension AssetListViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetList", for: indexPath) as! AssetListCollectionViewCell
        cell.asset = assets[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(assets[indexPath.item])
    }
}

extension AssetListViewModel {
    struct AssetList: Decodable {
        var assets: [Asset]
    }
}
