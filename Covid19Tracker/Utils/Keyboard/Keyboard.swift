//
//  Keyboard.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 13/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

enum Keyboard {
    struct Info {
        let animationCurve: UIView.AnimationCurve
        let duration: Double
        let isLocal: Bool
        let frameBegin: CGRect
        let frameEnd: CGRect

        fileprivate static func from(_ notification: Foundation.Notification) -> Keyboard.Info {
            let animationCurveObject: NSNumber = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
            let animationCurve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: animationCurveObject.intValue)!

            let duration: Double = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let isLocal: Bool = (notification.userInfo![UIResponder.keyboardIsLocalUserInfoKey] as! NSNumber).boolValue
            let frameBegin: CGRect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let frameEnd: CGRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

            return Info(animationCurve: animationCurve, duration: duration, isLocal: isLocal, frameBegin: frameBegin, frameEnd: frameEnd)
        }
    }

    enum Notification {
        struct WillShow { let info: Keyboard.Info }
        struct DidShow { let info: Keyboard.Info }
        struct WillHide { let info: Keyboard.Info }
        struct DidHide { let info: Keyboard.Info }
        struct WillChangeFrame { let info: Keyboard.Info }
        struct DidChangeFrame { let info: Keyboard.Info }
    }
}

extension Keyboard.Notification.WillShow: NotificationDescriptor {
    static var name: Notification.Name { return UIResponder.keyboardWillShowNotification }
    init(notification: Notification) { info = .from(notification) }
}

extension Keyboard.Notification.DidShow: NotificationDescriptor {
    static var name: Notification.Name { return UIResponder.keyboardDidShowNotification }
    init(notification: Notification) { info = .from(notification) }
}

extension Keyboard.Notification.WillHide: NotificationDescriptor {
    static var name: Notification.Name { return UIResponder.keyboardWillHideNotification }
    init(notification: Notification) { info = .from(notification) }
}

extension Keyboard.Notification.DidHide: NotificationDescriptor {
    static var name: Notification.Name { return UIResponder.keyboardDidHideNotification }
    init(notification: Notification) { info = .from(notification) }
}

extension Keyboard.Notification.WillChangeFrame: NotificationDescriptor {
    static var name: Notification.Name { return UIResponder.keyboardWillChangeFrameNotification }
    init(notification: Notification) { info = .from(notification) }
}

extension Keyboard.Notification.DidChangeFrame: NotificationDescriptor {
    static var name: Notification.Name { return UIResponder.keyboardDidChangeFrameNotification }
    init(notification: Notification) { info = .from(notification) }
}
