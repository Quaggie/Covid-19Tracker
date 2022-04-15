//
//  CareUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class CareUIComposer: UIComposer {
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

    func compose() -> CareViewController {
        let presenter = CarePresenter()
        let viewController = CareViewController(
            presenter: presenter,
            delegate: CareTrackerAdapter(),
            dataSource: dataSource,
            delegateFlowLayout: delegateFlowLayout,
            pageSelectorViewDelegate: pageSelectorDelegatesComposite
        )
        viewController.tabBarItem = UITabBarItem(title: "Care", image: UIImage(named: "tabbar_care"), tag: 4)

        pageSelectorDelegatesComposite.addDelegate(viewController)
        pageSelectorDelegatesComposite.addDelegate(careDataSource)
        pageSelectorDelegatesComposite.addDelegate(presenter)
        sourceDataSource.viewControllerPresenter = WeakRefVirtualProxy(viewController)
        return viewController
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
