//
//  AssetListViewController.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import UIKit

class AssetListViewController: BasedViewController<AssetListViewModel> {
    
    init() {
        super.init(viewModel: AssetListViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchAssets()
    }
    

}
