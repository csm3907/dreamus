//
//  VideoView.swift
//  dreamus
//
//  Created by USER on 2023/10/06.
//

import UIKit
import SnapKit
import Kingfisher

final class VideoView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fiveguys")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Shooting Start (Live Clip)"
        lbl.font = .systemFont(ofSize: 13, weight: .bold)
        return lbl
    }()
    
    lazy var artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "케이시"
        lbl.font = .systemFont(ofSize: 11, weight: .light)
        return lbl
    }()
    
    lazy var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "03:19"
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .white
        lbl.backgroundColor = .black.withAlphaComponent(0.7)
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(artistLabel)
        addSubview(timeLabel)
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.leading.equalTo(imageView.snp.leading)
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(imageView.snp.leading)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(imageView.snp.trailing).offset(-20)
            $0.bottom.equalTo(imageView.snp.bottom).offset(-20)
        }
    }
    
    func prepare(image: String = "", artistText: String?, titleText: String?, timeText: String?) {
        imageView.kf.setImage(with: URL(string: image))
        artistLabel.text = artistText
        titleLabel.text = titleText
        timeLabel.text = timeText
    }
}
