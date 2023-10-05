//
//  VideoCell.swift
//  dreamus
//
//  Created by USER on 2023/10/06.
//

import UIKit
import SnapKit

class VideoCell: UICollectionViewCell {
    
    lazy var videoView: VideoView = {
        let view = VideoView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(videoView)
        
        videoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //videoView.prepare(image: nil, artistText: nil, titleText: nil, timeText: nil)
    }
    
}
