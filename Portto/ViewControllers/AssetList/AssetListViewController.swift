//
//  AssetListViewController.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import UIKit

class AssetListViewController: BasedViewController<AssetListViewModel> {
    lazy var loadingView = AppLoadingView()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5.basedOnScreenWidth(), left: 10.basedOnScreenWidth(), bottom: 5.basedOnScreenWidth(), right: 10.basedOnScreenWidth())
        layout.itemSize = CGSize(width: 160.basedOnScreenWidth(), height: 200.basedOnScreenWidth())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(AssetListCollectionViewCell.self, forCellWithReuseIdentifier: "AssetList")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: Object life cycle
    init() {
        super.init(viewModel: AssetListViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARKL View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchAssets()
    }
    
    override func setUpAndLayoutViews() {
        super.setUpAndLayoutViews()
        
        title = "Assets"
        view.backgroundColor = .systemBackground
        view.addSafeFilledSubview(collectionView)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.onLoading = { [weak self] in
            guard let self = self else {
                return
            }
            (self.viewModel.isLoading && self.viewModel.assets.isEmpty) ? self.loadingView.show(on: self.view) : self.loadingView.hide()
        }
        
        viewModel.onAssetsFetch = { [weak self] (error) in
            if let error = error {
                if (self?.viewModel.assets.isEmpty ?? true) {
                    self?.showError(error)
                }
            } else {
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionView delegate
extension AssetListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = viewModel.assets[indexPath.item]
        let assetPage = AssetViewController(asset: asset)
        navigationController?.pushViewController(assetPage, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item > viewModel.assets.count - 8 {
            viewModel.fetchAssets()
        }
    }
}

// MARK: UICollectionView data source
extension AssetListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetList", for: indexPath) as! AssetListCollectionViewCell
        cell.asset = viewModel.assets[indexPath.item]
        return cell
    }
}
