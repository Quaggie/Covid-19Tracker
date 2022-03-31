//
//  CareViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class CareViewController: BaseViewController {
    // MARK: - Properties
    private let tracker: TrackerProtocol
    private var selectedIndex: Int = 0
    private weak var dataSource: DataSource?
    private weak var delegate: UICollectionViewDelegateFlowLayout?
    private let collectionViewInset: UIEdgeInsets = .init(top: 8, left: 16, bottom: 16, right: 16)

    // MARK: - Views
    private let titleLabel = UILabel(text: "Care", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var pageSelectorView = PageSelectorView(titles: ["Prevention", "Symptoms"], selectedTitle: "Prevention")
    private(set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = dataSource
        cv.delegate = delegate
        cv.backgroundColor = .clear
        cv.contentInset = collectionViewInset

        let bv = UIView()
        bv.backgroundColor = .clear
        cv.backgroundView = bv

        return cv
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Init
    init(
        tracker: TrackerProtocol = Tracker(source: String(describing: CareViewController.self)),
        dataSource: DataSource?,
        delegate: UICollectionViewDelegateFlowLayout?,
        pageSelectorViewDelegate: PageSelectorViewDelegate
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.tracker = tracker
        super.init(nibName: nil, bundle: nil)

        dataSource?.registerCells(on: collectionView)
        pageSelectorView.delegate = pageSelectorViewDelegate
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracker.screenView(name: "Preventions")
    }
}

extension CareViewController: PageSelectorDelegate {
    func pageSelectorDidChange(index: Int) {
        if selectedIndex == index, collectionView.numberOfSections > 0, collectionView.numberOfItems(inSection: 0) > 0 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        } else {
            if index == 0 {
                tracker.screenView(name: "Preventions")
            } else {
                tracker.screenView(name: "Symptoms")
            }
            selectedIndex = index
            collectionView.reloadData()
        }
    }
}

extension CareViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(pageSelectorView)
        view.addSubview(collectionView)
    }

    func setupConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          insets: .init(top: 36, left: collectionViewInset.left, bottom: 0, right: collectionViewInset.right))

        pageSelectorView.anchor(top: titleLabel.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                insets: .init(top: 27, left: collectionViewInset.right, bottom: 0, right: collectionViewInset.right))

        collectionView.anchor(top: pageSelectorView.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)
    }

    func setupAdditionalConfiguration() {
        pageSelectorView.setup()
    }
}
