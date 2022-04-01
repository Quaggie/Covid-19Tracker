//
//  TabBarViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {
    private lazy var trackerAdaptor = CareTrackerAdaptor()
    private lazy var careDataSource = CareDataSource(preventionModels: setupPreventionData(), symptomModels: setupSymptomsData())
    private lazy var sourceDataSource = SourceDataSource()
    private lazy var dataSource = DataSourceComposite(dataSources: [careDataSource, sourceDataSource])
    private lazy var delegateFlowLayout = DelegateFlowLayoutComposite(
        delegateFlowLayouts: [
            CareDelegateFlowLayout(),
            SourceDelegateFlowLayout()
        ]
    )
    private let pageSelectorDelegatesComposite = PageSelectorDelegatesComposite()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        tabBar.isOpaque = true
        tabBar.backgroundColor = Color.white
        delegate = self

        let homeViewController = HomeViewController(
            countryService: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoService: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tabbar_home"), tag: 0)

        let worldViewController = WorldViewController(
            worldService: MainQueueDispatchDecorator(instance: WorldService()),
            countryService: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoService: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        worldViewController.tabBarItem = UITabBarItem(title: "World", image: UIImage(named: "tabbar_world"), tag: 1)

        let searchViewController = makeSearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "search_icon"), tag: 2)

        let newsViewController = NewsViewController(newsService: MainQueueDispatchDecorator(instance: NewsService()))
        newsViewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "tabbar_news"), tag: 3)

        let careViewController = makeCareViewController()
        careViewController.tabBarItem = UITabBarItem(title: "Care", image: UIImage(named: "tabbar_care"), tag: 4)

        viewControllers = [homeViewController, worldViewController, searchViewController, newsViewController, careViewController]
    }

    private func makeSearchViewController() -> SearchViewController {
        SearchViewController(cameFromHome: false, countryService: MainQueueDispatchDecorator(instance: CountryService()))
    }

    private func makeCareViewController() -> CareViewController {
        let careViewController = CareViewController(
            delegate: trackerAdaptor,
            dataSource: dataSource,
            delegateFlowLayout: delegateFlowLayout,
            pageSelectorViewDelegate: pageSelectorDelegatesComposite
        )

        pageSelectorDelegatesComposite.addDelegate(careViewController)
        pageSelectorDelegatesComposite.addDelegate(careDataSource)
        pageSelectorDelegatesComposite.addDelegate(careDataSource)
        sourceDataSource.viewControllerPresenter = WeakRefVirtualProxy(careViewController)
        return careViewController
    }

    private func setupPreventionData() -> [CareModel] {
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

        return [
            washHandsModel,
            coverNoseAndMouthModel,
            dontTouchFaceModel,
            avoidCloseContactModel,
            stayHomeIcon
        ]
    }

    private func setupSymptomsData() -> [CareModel] {
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

        return [coughModel, feverModel, tirednessModel, difficultyBreathingModel]
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is SearchViewController {
            let controller = makeSearchViewController()
            present(controller, animated: true)
            return false
        }

        return true
    }
}

final class CareTrackerAdaptor {
    private let tracker: TrackerProtocol
    private var selectedIndex = 0

    init(tracker: TrackerProtocol = Tracker(source: String(describing: CareViewController.self))) {
        self.tracker = tracker
    }

    private func trackScreenFor(index: Int) {
        if index == 0 {
            tracker.screenView(name: "Preventions")
        } else {
            tracker.screenView(name: "Symptoms")
        }
    }
}

extension CareTrackerAdaptor: PageSelectorDelegate {
    func pageSelectorDidChange(index: Int) {
        guard selectedIndex != index else { return }
        selectedIndex = index
        trackScreenFor(index: index)
    }
}

extension CareTrackerAdaptor: CareViewControllerDelegate {
    func viewDidAppear() {
        trackScreenFor(index: selectedIndex)
    }
}
