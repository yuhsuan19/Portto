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
    
    // MARK: Fetch eth balance
    var ethBalance: Int64 = 0 {
        didSet {
            onETHBalanceFetch?(nil)
        }
    }
    var onETHBalanceFetch: ((Error?) -> Void)?
    func fetchETHBalance() {
        networkServiceProvider.request(for: InfuraAPI.getBalance) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let parser = try? JSONDecoder().decode(ETHBalance.self, from: response.data) else {
                    self?.onETHBalanceFetch?(AppError.networkFailed)
                    return
                }
                self?.ethBalance = parser.balance
            case .failure(let error):
                self?.onETHBalanceFetch?(error)
            }
        }
    }
}

extension AssetListViewModel {
    struct AssetList: Decodable {
        let assets: [Asset]
    }
    
    struct ETHBalance: Decodable {
        let result: String
        
        var balance: Int64 {
            let hex = result.replacingOccurrences(of: "0x", with: "")
            return Int64(hex, radix: 16) ?? 0
        }
    }
}
