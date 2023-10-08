//
//  ImageCell.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.layer.borderWidth = 0.5
        
        self.contentView.addSubview(imageView)
        imageView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(imageUrl: String) {
        imageView.setImage(fromURL: imageUrl)
    }
}

