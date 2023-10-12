//
//  DetailViewController.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class DetailViewController: UIViewController, ReactorKit.View {
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return lbl
    }()
    
    lazy var subTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .light)
        return lbl
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .black
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    lazy var lyricsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20, weight: .medium)
        textView.textAlignment = .center
        return textView
    }()
    
    var disposeBag = DisposeBag()
    let artistName: String?
    let trackID: Int
    
    init(viewModel: HomeViewModel, trackID: Int, artistName: String) {
        self.artistName = artistName
        self.trackID = trackID
        super.init(nibName: nil, bundle: nil)
        reactor = viewModel
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: HomeViewModel) {
        reactor.state
            .compactMap { $0.resetDetailVC }
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.lyricsTextView.text = ""
                self.titleLabel.text = ""
                self.subTitleLabel.text = ""
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.trackDetailInfo }
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                self.lyricsTextView.text = model.data?.lyrics ?? "가사 정보 없음"
                self.titleLabel.text = model.data?.name
                self.subTitleLabel.text = self.artistName
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .asDriver()
            .drive(with: self) { vc, _ in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        reactor?.action.onNext(.getTrackDetail(trackID: trackID))
    }
    
    deinit {
        print("DetailViewController deinit")
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(closeButton)
        view.addSubview(lyricsTextView)
        
        titleLabel.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        closeButton.snp.remakeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        lyricsTextView.snp.remakeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
}
