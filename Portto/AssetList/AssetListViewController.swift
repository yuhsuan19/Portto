//
//  AssetListViewController.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import UIKit

class AssetListViewController: BasedViewController<AssetListViewModel> {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5.basedOnScreenWidth(), left: 10.basedOnScreenWidth(), bottom: 5.basedOnScreenWidth(), right: 10.basedOnScreenWidth())
        layout.itemSize = CGSize(width: 160.basedOnScreenWidth(), height: 200.basedOnScreenWidth())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(AssetListCollectionViewCell.self, forCellWithReuseIdentifier: "AssetList")
        
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
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
        view.backgroundColor = .systemBackground
        view.addSafeFilledSubview(collectionView)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.onAssetsFetch = { [weak self] (error) in
            self?.collectionView.reloadData()
        }
    }
}
