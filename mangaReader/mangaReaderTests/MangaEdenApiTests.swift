//
//  MangaEdenApiTests.swift
//  DatarequestorTests
//
//  Created by Yiming Dong on 2018/11/11.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import mangaReader

class MangaEdenApiTests: XCTestCase {

    func test_getCategoryRecommend() {
        let exp = expectation(description: "should finish request")
        MangaEdenApi.getCategoryRecommend(){ (response, error) in
            exp.fulfill()
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.mangalist)
            XCTAssertFalse(response?.mangalist?.isEmpty ?? true)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }
    
    func test_getTopMangaList() {
        let exp = expectation(description: "should finish request")
        MangaEdenApi.getTopMangaList(){ (response, error) in
            exp.fulfill()
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.mangalist)
            XCTAssertFalse(response?.mangalist?.isEmpty ?? true)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }

}
