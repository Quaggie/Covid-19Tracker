//
//  NewsViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

protocol NewsViewControllerDelegate {
    func viewDidAppear()
}

final class NewsViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    // MARK: - Properties
    private var state: State = .loading {
        didSet {
            changeUIFor(state: state)
        }
    }
    private let delegate: NewsViewControllerDelegate
    private let presenter: NewsPresenterDelegate
    private let dataSource: DataSource?
    private let delegateFlowLayout: UICollectionViewDelegateFlowLayout?
    private let collectionViewInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let newsLoader: NewsLoader
    
    // MARK: - Views
    private let titleLabel = UILabel(text: "News", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = dataSource
        cv.delegate = delegateFlowLayout
        cv.backgroundColor = .clear
        cv.contentInset = collectionViewInset

        let bv = UIView()
        bv.backgroundColor = .clear
        cv.backgroundView = bv

        return cv
    }()

    private let loadingView = LoadingView()
    private lazy var errorView = ErrorView(delegate: self)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Init
    init(
        delegate: NewsViewControllerDelegate,
        presenter: NewsPresenterDelegate,
        dataSource: DataSource?,
        delegateFlowLayout: UICollectionViewDelegateFlowLayout?,
        newsLoader: NewsLoader
    ) {
        self.delegate = delegate
        self.presenter = presenter
        self.dataSource = dataSource
        self.delegateFlowLayout = delegateFlowLayout
        self.newsLoader = newsLoader
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
        delegate.viewDidAppear()
    }

    // MARK: - Private functions
    private func registerCells() {
        dataSource?.registerCells(on: collectionView)
    }

    private func fetchData() {
        state = .loading

        presenter.fetch { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let news):
                self.state = .success
                self.newsLoader.load(news: news)
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
                          insets: .init(top: 36, left: collectionViewInset.left, bottom: 0, right: collectionViewInset.right))

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

    func setupAdditionalConfiguration() {}
}
