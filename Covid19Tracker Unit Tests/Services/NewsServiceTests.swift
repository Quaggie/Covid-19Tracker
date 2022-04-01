//
//  NewsServiceTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 27/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker
import Networking

class NewsServiceTests: XCTestCase {
    func test_fetch_callsServiceOncePerExecution() {
        let (sut, networkManager) = makeSUT()

        sut.fetch { _ in }

        XCTAssertEqual(networkManager.messagesCount, 1)
    }

    func test_fetch_returnsNewsOnSuccess() {
        let (sut, networkManager) = makeSUT()

        let newsArray = [News(source: .init(name: ""), title: "", url: "", urlToImage: "", publishedAt: "")]
        let newsResponse = NewsResponse(status: "", totalResults: 1, articles: newsArray)
        expect(sut: sut, with: .success(newsArray)) {
            let data = try! JSONEncoder().encode(newsResponse)
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetch_returnsUnparseableErrorForWrongJSON() {
        let (sut, networkManager) = makeSUT()

        expect(sut: sut, with: .failure(.unparseable)) {
            let data = try! JSONSerialization.data(withJSONObject: anyJSONObject())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetch_returnsCorrectErrorForFailure() {
        let (sut, networkManager) = makeSUT()

        expect(sut: sut, with: .failure(.internalServerError)) {
            networkManager.complete(with: .failure(.internalServerError))
        }
    }
}

extension NewsServiceTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (NewsService, NetworkManagerSpy) {
        let networkManager = NetworkManagerSpy()
        let service = NewsService(networkManager: networkManager)
        checkMemoryLeak(for: networkManager, file: file, line: line)
        checkMemoryLeak(for: service, file: file, line: line)
        return (service, networkManager)
    }

    func expect(sut: NewsService, with expectedResult: Result<[News], WebserviceError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        var receivedResult: Result<[News], WebserviceError>?
        sut.fetch { result in
            receivedResult = result
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)

        switch (receivedResult, expectedResult) {
        case (.success(let receivedData), .success(let expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        case (.failure(let receivedError), .failure(let expectedError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Should've completed with \(expectedResult) instead got \(String(describing: receivedResult))", file: file, line: line)
        }
    }
}
