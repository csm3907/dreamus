//
//  ChartView.swift
//  dreamus
//
//  Created by USER on 2023/10/05.
//

import UIKit
import ReactorKit
import RxSwift

class ChartView: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
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
    
    lazy var pageControl: UIPageControl = {
        let control =  UIPageControl()
        return control
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, DreamUsList.TrackList>?
    private var reactor: HomeViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        configureCollectionView()
        performQuery(with: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
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
        section.visibleItemsInvalidationHandler = { (items, contentOffset, environment) -> Void in
            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
            self.pageControl.currentPage = currentPage
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    private func setupView() {
        backgroundColor = .lightGray
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(timeLabel)
        addSubview(collectionView)
        addSubview(pageControl)
        
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
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func performQuery(with filter: DreamUsList.ChartList?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DreamUsList.TrackList>()
        snapshot.appendSections([.start])
        
        let itemsInSection1 = filter?.trackList ?? []
        snapshot.appendItems(itemsInSection1)
        
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCollectionView() {
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: "ChartCell")
        collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource<Section, DreamUsList.TrackList>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCell", for: indexPath) as? ChartCell
            if let imageUrl = item.album?.imgList?.first?.url, let title = item.name, let artist = item.representationArtist?.name {
                cell?.prepare(image: imageUrl, descText: artist, titleText: title, numbering: indexPath.row)
            }
            return cell
        }
    }
    
    func configure(title: String, subTitle: String, time: String, pageCount: Int) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        timeLabel.text = time
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
    }
    
    func configureViewModel(viewModel: HomeViewModel?) {
        reactor = viewModel
        bind()
    }
    
    private func bind() {
        
    }
    
}

extension ChartView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = dataSource?.itemIdentifier(for: indexPath)
        let trackID = selectedItem?.id
        let artistName = selectedItem?.representationArtist?.name
        
        reactor?.action.onNext(.selectItem(trackID: trackID, artistName: artistName))
    }
}
