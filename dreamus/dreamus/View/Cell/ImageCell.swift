//
//  ImageCell.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: URL(string: ""))
        imageView.image = nil
    }
    
    func setupViews() {
        self.contentView.layer.borderWidth = 0.5
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        imageView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    func configure(imageUrl: String, title: String) {
        if let imageURL = URL(string: imageUrl) {
            UIImage.loadImage(fromURL: imageURL) { [weak self] (modifiedImage) in
                guard let self else { return }
                if let modifiedImage = modifiedImage {
                    DispatchQueue.main.async {
                        self.imageView.image = modifiedImage
                    }
                    
                }
            }
        }
        titleLabel.text = title
    }
}

