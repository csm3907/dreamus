//
//  SectionView.swift
//  dreamus
//
//  Created by USER on 2023/10/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SectionView: UIView {
    
    let items = ["차트", "장르/테마", "오디오", "영상"]
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 5, left: 16, bottom: 5, right: 16)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private func
    
    private func bind() {
        
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(CircleCollectionMenuCell.self, forCellWithReuseIdentifier: "CircleCollectionMenuCell")
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension SectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollectionMenuCell", for: indexPath) as! CircleCollectionMenuCell
        cell.configure(name: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CircleCollectionMenuCell.fittingSize(availableHeight: 36, name: items[indexPath.item])
        return CGSize(width: size.width + CGFloat(5), height: size.height)
    }
}
