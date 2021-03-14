//
//  AssetViewController.swift
//  Portto
//
//  Created by CHI on 2021/3/12.
//

import UIKit
import Kingfisher

class AssetViewController: BasedViewController<AssetViewModel> {
    private lazy var scrollView = LayoutScrollView()
    
    private lazy var imageView: LayoutImageView = {
        let imageView = LayoutImageView()
        imageView.kf.setImage(with: viewModel.asset.image_url?.imageResource, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (image, _, _, _) in
            if let image = image {
                self?.imageViewHeightConstraint?.constant = (image.size.height / image.size.width) * 300.basedOnScreenHeight()
                self?.view.layoutIfNeeded()
            } else {
                self?.imageView.backgroundColor = .systemGray5
            }
        }
        return imageView
    }()
    var imageViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var nameLabel = LayoutLabel(text: viewModel.asset.name, textColor: .secondaryLabel, fontSize: 18.basedOnScreenWidth(), fontWeight: .medium)
    
    private lazy var descriptionLabel: LayoutLabel = {
        let label = LayoutLabel(text: viewModel.asset.desc, textColor: .tertiaryLabel, fontSize: 16.basedOnScreenWidth())
        label.numberOfLines = 0
        return label
    }()
    
    @objc private lazy var actionButton: LayoutButton = {
        let button = LayoutButton(title: "permalink", target: self, action: #selector(onActionButtonTap), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18.basedOnScreenWidth(), weight: .medium)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    // MARK: Object life cycle
    init(asset: Asset) {
        let viewModel = AssetViewModel(asset: asset)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    override func setUpAndLayoutViews() {
        super.setUpAndLayoutViews()
        
        title = viewModel.asset.collection?.name
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "Asset List", style: .plain, target: nil, action: nil)
        
        view.addFilledSubView(scrollView)
        scrollView.addCenterXSubview(imageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 300.basedOnScreenWidth())
        imageViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25.basedOnScreenWidth()),
            imageView.widthAnchor.constraint(equalToConstant: 300.basedOnScreenWidth()),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.basedOnScreenWidth()),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: imageView.widthAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15.basedOnScreenWidth()),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(lessThanOrEqualTo: imageView.widthAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -90.basedOnScreenWidth())
        ])
        
        view.addCenterXSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            actionButton.heightAnchor.constraint(equalToConstant: 44.basedOnScreenWidth()),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30.basedOnScreenWidth())
        ])
        addObservedKeyPath(#keyPath(actionButton.bounds)) { [weak self] in
            guard let self = self else {
                return
            }
            self.actionButton.layer.cornerRadius = self.actionButton.bounds.height * 0.5
        }
    }
    
    // MARK: User action
    @objc func onActionButtonTap() {
        if let url = viewModel.asset.permalink {
            UIApplication.shared.open(url, options: [:], completionHandler: { _ in})
        }
    }
}
