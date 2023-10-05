//
//  VideoHeader.swift
//  dreamus
//
//  Created by USER on 2023/10/05.
//

import UIKit
import SnapKit

final class VideoHeader: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "비디오"
        return lbl
    }()
    
    lazy var videoView: VideoView = {
        let view = VideoView()
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(videoView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        self.videoView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //videoView.prepare(image: nil, artistText: nil, titleText: nil, timeText: nil)
    }
    
}

