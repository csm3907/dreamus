//
//  CommonHeaderView.swift
//  dreamus
//
//  Created by USER on 2023/10/06.
//

import UIKit
import SnapKit

final class CommonHeaderView: UICollectionReusableView {
    lazy var sectionLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sectionLabel)
        
        self.sectionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //sectionLabel.text = nil
    }
    
}
