//
//  AssetListCollectionViewCell.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import UIKit

class AssetListCollectionViewCell: BasedCollectionViewCell {
    var asset: Asset? {
        didSet {
            imageView.kf.setImage(with: asset?.image_thumbnail_url?.imageResource)
            textLabel.text = asset?.name
        }
    }
    
    private lazy var imageView = LayoutImageView()
    private lazy var textLabel = LayoutLabel(textColor: .secondaryLabel, textAlignment: .center, fontSize: 18.basedOnScreenWidth(), fontWeight: .medium)
    
    override func setUpAndLayoutViews() {
        super.setUpAndLayoutViews()
        
        contentView.addCenterXSubview(imageView)
        contentView.addCenterXSubview(textLabel)
                
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.basedOnScreenWidth()),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: (15 / 16)),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: (15 / 16))
        ])
    }
}
