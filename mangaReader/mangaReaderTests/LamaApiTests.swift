//
//  LamaApiTests.swift
//  mangaReaderTests
//
//  Created by Yiming Dong on 2018/12/8.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import mangaReader

class LamaApiTests: XCTestCase {
    
    func test_getTopic_ok() {
        let exp = expectation(description: "should finish request")
        LamaApi.getTopic(id: 19331) { (response, error) in
            exp.fulfill()
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.data)
            XCTAssertFalse(response?.data?.comics?.isEmpty ?? true)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }
}