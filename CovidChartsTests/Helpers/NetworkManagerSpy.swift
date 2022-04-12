//
//  NetworkManagerSpy.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 27/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

final class NetworkManagerSpy: NetworkManagerProtocol {
    var urlStrings: [String] = []
    var fetchCompletionMessages: [(Result<Data, NetworkError>) -> Void] = []
    var messagesCount: Int {
        fetchCompletionMessages.count
    }

    @discardableResult
    func fetch(urlString: String, method: HTTPMethod, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<Data, NetworkError>) -> Void) -> NetworkRequest? {
        urlStrings.append(urlString)
        fetchCompletionMessages.append(completion)
        return nil
    }

    func complete(with result: Result<Data, NetworkError>, at index: Int = 0) {
        fetchCompletionMessages[index](result)
    }
}
