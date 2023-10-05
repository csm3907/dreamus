//
//  ChartView.swift
//  dreamus
//
//  Created by USER on 2023/10/05.
//

import UIKit

class ChartView: UICollectionViewCell {
    
    enum Section: Hashable {
        case start
    }
    
    struct Item: Hashable {
        let identifier: String
    }
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Flo Theme"
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    lazy var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "11시간 전"
        lbl.font = .systemFont(ofSize: 11, weight: .light)
        return lbl
    }()
    
    lazy var subTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Flo Chart 순위 입니다."
        lbl.font = .systemFont(ofSize: 11, weight: .medium)
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getLayoutChartSection())
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .lightGray
        setupView()
        configureCollectionView()
        performQuery(with: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getLayoutChartSection() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 5
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(timeLabel)
        addSubview(collectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func performQuery(with filter: String?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.start])
        
        let itemsInSection1 = (1...12).map { Item(identifier: "\($0)") }
        snapshot.appendItems(itemsInSection1)
        
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCollectionView() {
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as? TestCell
            cell?.label?.text = item.identifier
            return cell
        }
    }
    
}
