//
//  ChartCell.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit
import Kingfisher

class ChartCell: UICollectionViewCell {
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        stackView.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        return stackView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fiveguys")
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var numberingLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lbl
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .lightGray
        descLabel.numberOfLines = 1
        descLabel.font = .systemFont(ofSize: 13)
        return descLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.horizontalStackView)
        self.horizontalStackView.addArrangedSubview(imageView)
        self.horizontalStackView.addArrangedSubview(numberingLabel)
        self.horizontalStackView.addArrangedSubview(self.verticalStackView)
        self.verticalStackView.addArrangedSubview(self.titleLabel)
        self.verticalStackView.addArrangedSubview(self.descLabel)
        
        self.horizontalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.height)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(image: "", descText: nil, titleText: nil, numbering: -1)
    }
    
    func prepare(image: String, descText: String?, titleText: String?, numbering: Int) {
        self.imageView.kf.setImage(with: URL(string: image))
        self.descLabel.text = descText
        self.titleLabel.text = titleText
        if numbering < 0 {
            self.numberingLabel.text = nil
        } else {
            self.numberingLabel.text = "\(numbering + 1)"
        }
    }
}


