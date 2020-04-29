//
//  Reachability.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 28/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol ReachabilityProtocol {
    func isConnectedToNetwork() -> Bool
}

final class Reachability: ReachabilityProtocol {
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else { return false }

        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else { return false }

        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
}

