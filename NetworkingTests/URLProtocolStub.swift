//
//  URLProtocolStub.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 28/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

struct Stub {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

final class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?
    private static let lockQueue = DispatchQueue(label: "name.lock.queue")

    static func startIntercepting() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    static func stopIntercepting() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        URLProtocolStub.lockQueue.async { [self] in
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }

            if let stub = URLProtocolStub.stub {
                if let response = stub.response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
                }

                if let data = stub.data {
                    client?.urlProtocol(self, didLoad: data)
                }

                if let error = stub.error {
                    client?.urlProtocol(self, didFailWithError: error)
                }

                client?.urlProtocolDidFinishLoading(self)
            }
        }
    }

    override func stopLoading() {
        URLProtocolStub.lockQueue.async {
            URLProtocolStub.requestObserver = nil
        }
    }

    static func observeRequest(with observer: @escaping (URLRequest) -> Void) {
        lockQueue.async {
            URLProtocolStub.requestObserver = observer
        }
    }

    static func stub(_ stub: Stub?) {
        lockQueue.async {
            URLProtocolStub.stub = stub
        }
    }
}
