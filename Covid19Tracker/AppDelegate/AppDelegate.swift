//
//  AppDelegate.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder {
    var window: UIWindow?
    private var mainCoordinator: MainCoordinator?

    private lazy var appDelegates: [UIApplicationDelegate] = [
        FirebaseAppDelegate()
    ]

    private func setupWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        return window
    }

    private func setupCoordinator() {
        let window = setupWindow()
        if !Self.isRunningTests {
            let mainCoordinator = MainCoordinator(window: window)
            self.mainCoordinator = mainCoordinator
            mainCoordinator.start()
        } else {
            window.rootViewController = UIViewController()
        }

        window.makeKeyAndVisible()
    }

    private func setupAppearance() {
        window?.tintColor = Color.blueDark
    }

    private func setupAppDelegates(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        if !Self.isRunningTests {
            appDelegates.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        }
    }
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupCoordinator()
        setupAppearance()
        setupAppDelegates(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
}

// MARKL: - Tests
extension AppDelegate {
    static var isRunningTests: Bool {
        return NSClassFromString("XCTest") != nil
        || ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        || NSClassFromString("XCUIApplication") != nil
    }
}
