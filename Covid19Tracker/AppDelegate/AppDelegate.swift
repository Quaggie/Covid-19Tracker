//
//  AppDelegate.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var appDelegates: [UIApplicationDelegate] = [
        FirebaseAppDelegate()
    ]

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupWindow()
        setupAppearance()
        setupAppDelegates(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppDelegate.isRunningTests ? UIViewController() : TabBarViewController()
        window?.makeKeyAndVisible()
    }

    private func setupAppearance() {
        window?.tintColor = Color.blueDark
    }

    private func setupAppDelegates(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        if !AppDelegate.isRunningTests {
            appDelegates.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        }
    }
}

extension AppDelegate {
    static var isRunningTests: Bool {
        return NSClassFromString("XCTest") != nil
        || ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        || NSClassFromString("XCUIApplication") != nil
    }
}
