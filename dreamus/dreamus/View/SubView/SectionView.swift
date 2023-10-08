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
    var disposeBag = DisposeBag()
    
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
    
    var reactor: HomeViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewModel(viewModel: HomeViewModel?) {
        self.reactor = viewModel
        
        bind()
    }
    
    // MARK: - Private func
    
    private func bind() {
        reactor?.state
            .compactMap { $0.section }
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] sectionIndex in
                guard let self else { return }
                //self.collectionView.selectItem(at: IndexPath(row: sectionIndex, section: 0), animated: false, scrollPosition: .left)
            }
            .disposed(by: disposeBag)
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
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.selectSection(sectionID: indexPath.row))
    }
}
