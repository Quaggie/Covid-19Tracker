//
//  NewsViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import SafariServices

final class NewsViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    // MARK: - Services
    private let newsService: NewsServiceProtocol

    // MARK: - Properties
    private var state: State = .loading {
        didSet {
            changeUIFor(state: state)
        }
    }
    private var datasource: [News] = []
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16
    private let interItemSpacing: CGFloat = 16
    
    // MARK: - Views
    private let titleLabel = UILabel(text: "News", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear

        let bv = UIView()
        bv.backgroundColor = .clear
        cv.backgroundView = bv

        return cv
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private let loadingView = LoadingView()
    private lazy var errorView = ErrorView(delegate: self)

    // MARK: - Init
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracker.screenView(name: "News")
    }

    // MARK: - Private functions
    private func registerCells() {
        collectionView.register(NewsCell.self)
    }

    private func fetchData() {
        state = .loading

        newsService.fetch { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let news):
                self.datasource = news
                self.state = .success
            case .failure:
                self.state = .error
            }
        }
    }

    private func changeUIFor(state: State) {
        switch state {
        case .loading:
            show(view: loadingView)
        case .success:
            show(view: collectionView)
            collectionView.reloadData()
        case .error:
            show(view: errorView)
        }
    }

    private func show(view: UIView) {
        [collectionView, loadingView, errorView].forEach { (v) in
            if view == v {
                v.isHidden = false
            } else {
                v.isHidden = true
            }
        }
    }

    @objc private func closeModal() {
        dismiss(animated: true)
    }
}

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = datasource[indexPath.item]
        let urlString = model.url
        guard let url = URL(string: urlString) else { return }

        let controller = SFSafariViewController(url: url)
        present(controller, animated: true)
    }
}

extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = datasource[indexPath.item]

        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as NewsCell
        cell.setup(model: model, index: indexPath.item)
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
        return NewsCell.size(width: width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
}

extension NewsViewController: ErrorViewDelegate {
    func errorViewDidTapTryAgain() {
        fetchData()
    }
}

extension NewsViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(errorView)

        view.addSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          insets: .init(top: 36, left: sectionInset.left, bottom: 0, right: sectionInset.right))

        collectionView.anchor(top: titleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)

        loadingView.anchor(top: titleLabel.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor,
                           trailing: view.trailingAnchor)
        errorView.anchor(top: titleLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
    }

    func setupAdditionalConfiguration() {

    }
}
