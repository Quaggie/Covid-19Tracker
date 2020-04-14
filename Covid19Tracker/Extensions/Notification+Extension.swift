//
//  Notification+Extension.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 13/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let onSearchCountry = Notification.Name("onSearchCountry")
}

extension Notification {
    class Token {
        let token: NSObjectProtocol
        let center: NotificationCenter

        init(token: NSObjectProtocol, center: NotificationCenter) {
            self.token = token
            self.center = center
        }

        deinit {
            center.removeObserver(token)
        }
    }
}

protocol NotificationDescriptor {
    static var name: Notification.Name { get }
    init(notification: Notification)
}

struct PostNotificationDescriptor<Type> {
    let name: Notification.Name
}

extension NotificationCenter {
    func addObserver<Descriptor: NotificationDescriptor>(queue: OperationQueue? = nil,
                                                         using block: @escaping (Descriptor) -> Void) -> Notification.Token {
        let token = addObserver(forName: Descriptor.name, object: nil, queue: queue) { notification in
            block(Descriptor(notification: notification))
        }

        return Notification.Token(token: token, center: self)
    }

    func post<Object>(descriptor: PostNotificationDescriptor<Object>, value: Object? = nil) {
        post(name: descriptor.name, object: value)
    }
}

