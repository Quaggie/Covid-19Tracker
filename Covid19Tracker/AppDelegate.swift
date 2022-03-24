//
//  AppDelegate.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        guard !AppDelegate.isRunningTests else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            let viewController = UIViewController()
            viewController.view.backgroundColor = .white
            window.rootViewController = viewController
            setupAppearance()
            window.makeKeyAndVisible()
            return true
        }

        setupWindow()
        setupAppearance()

        return true
    }

    private func setupAppearance() {
        window?.tintColor = Color.blueDark
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
    }

    private func setupFirebase() {
        FirebaseApp.configure()
    }
}

extension AppDelegate {
    static var isRunningTests: Bool {
        return NSClassFromString("XCTest") != nil
        || ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        || NSClassFromString("XCUIApplication") != nil
    }
}
