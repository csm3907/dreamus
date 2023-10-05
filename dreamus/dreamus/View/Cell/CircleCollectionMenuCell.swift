//
//  CircleCollectionMenuCell.swift
//  dreamus
//
//  Created by USER on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CircleCollectionMenuCell: UICollectionViewCell {
    
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = CircleCollectionMenuCell()
        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = .white
                layer.borderColor = UIColor.blue.cgColor
                titleLabel.font = .systemFont(ofSize: 12)
                backgroundColor = .blue
            } else {
                backgroundColor = .white
                titleLabel.textColor = .lightGray
                layer.borderColor = UIColor.darkGray.cgColor
                titleLabel.font = .systemFont(ofSize: 12)
            }
            
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    private func setupView() {
        backgroundColor = .white
        titleLabel.textAlignment = .center
        titleLabel.textColor = .lightGray
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
}

