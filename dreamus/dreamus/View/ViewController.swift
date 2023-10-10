//
//  ViewController.swift
//  dreamus
//
//  Created by USER on 2023/10/05.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, ReactorKit.View {
    
    lazy var sectionView: SectionView = {
        let view = SectionView(frame: .zero)
        view.backgroundColor = .white
        view.configureViewModel(viewModel: reactor)
        return view
    }()
    
    lazy var layout: UICollectionViewLayout = {
        let layout = getLayout()
        return layout
    }()
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    enum Section: Int {
        case chart
        case genre
        case audio
        case video
    }
    
    struct Item: Hashable {
        let identifier: Int
        
        let chartList: [DreamUsList.ChartList]?
        let genreList: [DreamUsList.SectionList]?
        let audioList: [DreamUsList.List]?
        let videoList: [DreamUsList.VideoList]?
    }
    
    var disposeBag = DisposeBag()
    typealias Reactor = HomeViewModel
    
    init() {
        super.init(nibName: nil, bundle: nil)
        reactor = HomeViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        setupUI()
        setCollectionView()
        makeDataSource()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: HomeViewModel) {
        reactor.state
            .compactMap { $0.listData }
            .asDriver(onErrorJustReturn: DreamUsList())
            .drive(with: self) { vc, listData in
                vc.performQuery(with: listData)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.detailVC }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] params in
                guard let self else { return }
                guard let trackID = params.trackID else { return }
                guard let artistName = params.artistName else { return }
                let detailVC = DetailViewController(viewModel: self.reactor ?? HomeViewModel(), trackID: trackID, artistName: artistName)
                self.present(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.section }
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] sectionIndex in
                guard let self else { return }
                let indexPathToScroll = IndexPath(item: 0, section: sectionIndex)
                if let headerAttributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPathToScroll) {
                    let headerFrame = headerAttributes.frame
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: headerFrame.origin.y), animated: true)
                } else {
                    self.collectionView.scrollToItem(at: indexPathToScroll, at: .top, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(sectionView)
        
        sectionView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func setCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(ChartView.self, forCellWithReuseIdentifier: "ChartView")
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.register(GenreView.self, forCellWithReuseIdentifier: "GenreView")
        collectionView.register(VideoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "VideoHeader")
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleHeaderView")
        collectionView.register(CommonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommonHeaderView")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sectionView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        collectionView.rx.didScroll
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                guard let indexPath = self.collectionView.indexPathsForVisibleItems.first else {
                    return
                }
                if self.collectionView.isTracking || self.collectionView.isDragging || self.collectionView.isDecelerating {
                    self.reactor?.action.onNext(.scrollSection(sectionID: indexPath.section))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func makeDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch Section(rawValue: indexPath.section) {
            case .chart:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartView", for: indexPath) as? ChartView
                let index = item.identifier
                let themeData = item.chartList?[index]
                if let title = themeData?.name, let subTItle = themeData?.description, let time = themeData?.basedOnUpdate {
                    let count = floor(Double((themeData?.trackList?.count ?? 0) / 5))
                    cell?.configure(title: title, subTitle: subTItle, time: time, pageCount: Int(count))
                }
                cell?.performQuery(with: themeData)
                cell?.configureViewModel(viewModel: self.reactor)
                return cell
                
            case .genre:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreView", for: indexPath) as? GenreView
                let index = item.identifier
                let genreData = item.genreList?[index]
                cell?.performQuery(with: genreData)
                if let title = genreData?.name {
                    cell?.configure(title: title)
                }
                return cell
                
            case .audio:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
                let index = item.identifier
                if let imageUrl = item.audioList?[index].imgUrl, let title = item.audioList?[index].displayTitle {
                    cell?.configure(imageUrl: imageUrl, title: title)
                }
                return cell
                
            case .video:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell
                cell?.backgroundColor = .white
                let index = item.identifier
                if let imageUrl = item.videoList?[index].thumbnailImageList?.first?.url, let title = item.videoList?[index].videoNm, let artist = item.videoList?[index].representationArtist?.name, let playTm = item.videoList?[index].playTm {
                    cell?.videoView.prepare(image: imageUrl, artistText: artist, titleText: title, timeText: playTm)
                }
                
                return cell
                
            case .none:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
                cell?.backgroundColor = .white
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
            
            switch Section(rawValue: indexPath.section) {
            case .chart:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommonHeaderView", for: indexPath) as? CommonHeaderView
                view?.sectionLabel.text = "차트"
                view?.backgroundColor = .white
                return view
                
            case .genre:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommonHeaderView", for: indexPath) as? CommonHeaderView
                view?.sectionLabel.text = "장르"
                view?.backgroundColor = .white
                return view
                
            case .audio:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommonHeaderView", for: indexPath) as? CommonHeaderView
                view?.sectionLabel.text = "오디오"
                view?.backgroundColor = .white
                return view
                
            case .video:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "VideoHeader", for: indexPath) as? VideoHeader
                view?.backgroundColor = .white
                
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let itemsInSection = self.dataSource.snapshot().itemIdentifiers(inSection: section)
                guard let videoListFirstItem = itemsInSection.first?.videoList?.first else { return view }
                if let thumbNail = videoListFirstItem.thumbnailImageList?.first?.url, let title = videoListFirstItem.videoNm, let artist = videoListFirstItem.representationArtist?.name, let playTm = videoListFirstItem.playTm {
                    view?.videoView.prepare(image: thumbNail, artistText: artist, titleText: title, timeText: playTm)
                }
                
                return view
                
            default:
                break
            }
            return UICollectionReusableView()
        }
    }
    
    func createVideoLayout() -> NSCollectionLayoutSection {
        let itemInset: CGFloat = 2.5
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createLayout() -> NSCollectionLayoutSection {
        let itemFractionalWidthFraction = 1.0 / 2.0
        let groupFractionalHeightFraction = 1.0 / 6.0
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
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func getChartLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.3)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func getGenreLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2.5)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout.init { sectionIndex, env in
            switch Section(rawValue: sectionIndex) {
            case .chart:
                return self.getChartLayout()
                
            case .genre:
                return self.getGenreLayout()
                
            case .audio:
                return self.createLayout()
                
            case .video:
                return self.createVideoLayout()
                
            case .none:
                return self.createLayout()
            }
        }
        return layout
    }
    
    func performQuery(with list: DreamUsList) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.chart, .genre, .audio, .video])
        
        let chartCount = list.data?.chartList?.count ?? 0
        let itemsInSection1 = (0..<chartCount).map { Item(identifier: $0, chartList: list.data?.chartList, genreList: nil, audioList: nil, videoList: nil)}
        snapshot.appendItems(itemsInSection1, toSection: .chart)
        
        let genreCount = list.data?.sectionList?.count ?? 0
        let itemsInSection2 = (0..<genreCount).map { Item(identifier: $0, chartList: nil, genreList: list.data?.sectionList, audioList: nil, videoList: nil)}
        snapshot.appendItems(itemsInSection2, toSection: .genre)
        
        let audioCount = list.data?.programCategoryList?.list?.count ?? 0
        let itemsInSection3 = (0..<audioCount).map { Item(identifier: $0, chartList: nil, genreList: nil, audioList: list.data?.programCategoryList?.list, videoList: nil)}
        snapshot.appendItems(itemsInSection3, toSection: .audio)
        
        let videoCount = list.data?.videoPlayList?.videoList?.count ?? 0
        let itemsInSection4 = (1..<videoCount).map { Item(identifier: $0, chartList: nil, genreList: nil, audioList: nil, videoList: list.data?.videoPlayList?.videoList)}
        snapshot.appendItems(itemsInSection4, toSection: .video)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
