//
//  GenreView.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit
import Kingfisher

class GenreView: UICollectionViewCell {
    
    enum Section: Hashable {
        case start
    }
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, DreamUsList.ShortcutList>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        configureCollectionView()
        performQuery(with: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLayout() -> UICollectionViewLayout {
        let items = floor(Double((dataSource?.snapshot().numberOfItems ?? 0) / 2))
        let itemFractionalWidthFraction = 1.0 / 2.0
        let groupFractionalHeightFraction: Double
        if items == Double(0.0) {
            groupFractionalHeightFraction = 1.0 / 6
        } else {
            groupFractionalHeightFraction = 1.0 / items
        }
        let itemInset: CGFloat = 2.5
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(groupFractionalHeightFraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        return UICollectionViewCompositionalLayout(section: section)
    }
        
    private func setupView() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    func performQuery(with filter: DreamUsList.SectionList?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DreamUsList.ShortcutList>()
        snapshot.appendSections([.start])
        
        let itemsInSection1 = filter?.shortcutList ?? []
        snapshot.appendItems(itemsInSection1)
        
        self.dataSource?.apply(snapshot, animatingDifferences: true)
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }
    
    private func configureCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        dataSource = UICollectionViewDiffableDataSource<Section, DreamUsList.ShortcutList>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
            if let imageUrl = item.imgList?.first?.url, let title = item.name {
                cell?.configure(imageUrl: imageUrl, title: title)
            }
            return cell
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
