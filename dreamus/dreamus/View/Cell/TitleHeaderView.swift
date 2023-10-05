//
//  TitleHeaderView.swift
//  dreamus
//
//  Created by USER on 2023/10/05.
//

import UIKit
import SnapKit

final class TitleHeaderView: UICollectionReusableView {
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        stackView.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        return stackView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fiveguys")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .lightGray
        descLabel.numberOfLines = 1
        descLabel.font = .systemFont(ofSize: 16)
        return descLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.horizontalStackView)
        self.horizontalStackView.addArrangedSubview(imageView)
        self.horizontalStackView.addArrangedSubview(self.verticalStackView)
        self.verticalStackView.addArrangedSubview(self.titleLabel)
        self.verticalStackView.addArrangedSubview(self.descLabel)
        
        self.horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        self.imageView.snp.makeConstraints {
            $0.size.equalTo(40)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(image: nil, descText: nil, titleText: nil)
    }
    
    func prepare(image: UIImage?, descText: String?, titleText: String?) {
        self.imageView.image = image
        self.descLabel.text = descText
        self.titleLabel.text = titleText
    }
}
