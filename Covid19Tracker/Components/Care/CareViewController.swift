//
//  CareViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import SafariServices

final class CareViewController: BaseViewController {
    enum DatasourceType {
        case card(CareModel)
        case source
    }

    // MARK: - Properties
    private var selectedIndex: Int = 0
    private var preventionDatasource: [DatasourceType] = []
    private var symptomsDatasource: [DatasourceType] = []
    private let collectionViewInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16

    // MARK: - Views
    private let titleLabel = UILabel(text: "Care", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var pageSelectorView = PageSelectorView(titles: ["Prevention", "Symptoms"], selectedTitle: "Prevention", delegate: self)
    private(set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate = self
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
        setupPreventionData()
        setupSymptomsData()
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracker.screenView(name: "Preventions")
    }

    private func registerCells() {
        collectionView.register(CareCardCell.self)
        collectionView.register(CareSourceCell.self)
    }

    private func setupPreventionData() {
        let washHandsModel = CareModel(title: "Wash your hands",
                                       color: Color.purpleLight,
                                       description: "Wash your hands regularly for 20 seconds, with soap and water or alcohol-based hand rub",
                                       image: UIImage(named: "prevention_wash_hands_icon")!)

        let coverNoseAndMouthModel = CareModel(title: "Cover nose and mouth",
                                               color: Color.greenDark,
                                               description: "Cover your nose and mouth with a disposable tissue or flexed elbow when you cough or sneeze",
                                               image: UIImage(named: "prevention_cough_icon")!)

        let dontTouchFaceModel = CareModel(title: "Do not touch your face",
                                           color: Color.blueLight,
                                           description: "Avoid close contact (1 meter or 3 feet) with people who are unwell",
                                           image: UIImage(named: "prevention_avoid_contact_icon")!)

        let avoidCloseContactModel = CareModel(title: "Avoid close contact",
                                               color: Color.yellowDark,
                                               description: "Avoid touching your eyes, nose, or mouth if your hands are not clean",
                                               image: UIImage(named: "prevention_dont_touch_face_icon")!)

        let stayHomeIcon = CareModel(title: "Stay home",
                                     color: Color.purpleLight,
                                     description: "Stay home and self-isolate from others in the household if you feel unwell",
                                     image: UIImage(named: "prevention_mask_icon")!)

        preventionDatasource = [
            .card(washHandsModel),
            .card(coverNoseAndMouthModel),
            .card(dontTouchFaceModel),
            .card(avoidCloseContactModel),
            .card(stayHomeIcon),
            .source
        ]
    }

    private func setupSymptomsData() {
        let coughModel = CareModel(title: "Cough",
                                   color: Color.purpleLight,
                                   description: "One of the most common symptoms is dry cough",
                                   image: UIImage(named: "symptom_cough")!)

        let feverModel = CareModel(title: "Fever",
                                   color: Color.greenDark,
                                   description: "Another common symptom is high fever",
                                   image: UIImage(named: "symptom_fever")!)

        let tirednessModel = CareModel(title: "Tiredness",
                                       color: Color.blueLight,
                                       description: "A person infected with the virus can experience unusual tiredness",
                                       image: UIImage(named: "symptom_tiredness")!)

        let difficultyBreathingModel = CareModel(title: "Difficulty breathing",
                                                 color: Color.yellowDark,
                                                 description: "In more severe cases, breathing may be difficult. This symptom requires medical help",
                                                 image: UIImage(named: "symptom_difficulty_breathing")!)

        symptomsDatasource = [.card(coughModel), .card(feverModel), .card(tirednessModel), .card(difficultyBreathingModel), .source]
    }
}

extension CareViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return preventionDatasource.count
        } else {
            return symptomsDatasource.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = selectedIndex == 0 ? preventionDatasource[indexPath.item] : symptomsDatasource[indexPath.item]

        switch item {
        case .card(let model):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CareCardCell
            cell.setup(model: model)
            return cell
        case .source:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CareSourceCell
            cell.onTapLink = { [weak self] in
                let url = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019")!
                let controller = SFSafariViewController(url: url)
                self?.present(controller, animated: true)
            }
            return cell
        }
    }
}

extension CareViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let item = selectedIndex == 0 ? preventionDatasource[indexPath.item] : symptomsDatasource[indexPath.item]

        switch item {
        case .card:
            let width: CGFloat = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
            return .init(width: width, height: CareCardCell.height)
        case .source:
            let width: CGFloat = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
            return .init(width: width, height: CareSourceCell.height)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return lineSpacing
    }
}

extension CareViewController: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        if selectedIndex == index {
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
