//
//  DatarequestorTests.swift
//  DatarequestorTests
//
//  Created by Yiming Dong on 2018/11/11.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import mangaReader

class DatarequestorTests: XCTestCase {

    func testReportBad() {
        let exp = expectation(description: "should finish request")
        DataRequester.reportBad(mangaId: "1234", chapterId: "1234", reason: "Adult") { (response, error) in
            exp.fulfill()
            XCTAssertNotNil(response)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }

}
