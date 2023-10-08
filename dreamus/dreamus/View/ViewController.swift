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
        return view
    }()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, DreamUsList>!
    
    enum Section: Int {
        case chart
        case genre
        case audio
        case video
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: getLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(ChartView.self, forCellWithReuseIdentifier: "ChartView")
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.register(VideoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "VideoHeader")
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleHeaderView")
        collectionView.register(CommonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommonHeaderView")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sectionView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func makeDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DreamUsList>(collectionView: collectionView) { collectionView, indexPath, item in
            switch Section(rawValue: indexPath.section) {
            case .chart:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartView", for: indexPath) as? ChartView
                cell?.performQuery(with: "")
                return cell
                
            case .genre:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
                cell?.backgroundColor = .yellow
                
                return cell
                
            case .audio:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
                cell?.backgroundColor = .red
                return cell
                
            case .video:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell
                cell?.backgroundColor = .white
                // TODO: cell setup
                
                //cell?.videoView.prepare(image: nil, artistText: nil, titleText: nil, timeText: nil)
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
            heightDimension: .absolute(500)
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
    
    private func getLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.init { sectionIndex, env in
            switch Section(rawValue: sectionIndex) {
            case .chart:
                return self.getChartLayout()
                
            case .genre:
                return self.createLayout()
                
            case .audio:
                return self.createLayout()
                
            case .video:
                return self.createVideoLayout()
                
            case .none:
                return self.createLayout()
            }
        }
    }
    
    func performQuery(with list: DreamUsList) {
        guard let listData = list.data else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, DreamUsList>()
        snapshot.appendSections([.chart, .genre, .audio, .video])
        
        let itemsInSection1 = [list]
        for _ in 0...10 {
            snapshot.appendItems([list])
        }
//        snapshot.appendItems(itemsInSection1, toSection: .chart)
//        snapshot.appendItems(itemsInSection1, toSection: .genre)
//        snapshot.appendItems(itemsInSection1, toSection: .audio)
//        snapshot.appendItems(itemsInSection1, toSection: .video)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

