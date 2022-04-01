//
//  FirebaseAppDelegate.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import Firebase

final class FirebaseAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
