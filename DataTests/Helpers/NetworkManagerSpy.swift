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
    var fetchCompletionMessages: [(Result<Data, WebserviceError>) -> Void] = []
    var messagesCount: Int {
        fetchCompletionMessages.count
    }

    @discardableResult
    func fetch(urlString: String, method: HTTPMethod, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<Data, WebserviceError>) -> Void) -> WebserviceRequest? {
        fetchCompletionMessages.append(completion)
        return nil
    }

    func complete(with result: Result<Data, WebserviceError>, at index: Int = 0) {
        fetchCompletionMessages[index](result)
    }
}
