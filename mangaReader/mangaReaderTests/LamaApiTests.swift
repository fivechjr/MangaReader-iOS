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
    
    func test_getChapter_ok() {
        let exp = expectation(description: "should finish request")
        LamaApi.getChapter(id: 658812) { (response, error) in
            exp.fulfill()
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.data)
            XCTAssertFalse(response?.data?.chapterImages?.isEmpty ?? true)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }
    
    func test_search_ok() {
        let exp = expectation(description: "should finish request")
        LamaApi.search(keyword: "one", offset: 0, limit: 20) { (response, error) in
            exp.fulfill()
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.data)
            XCTAssertFalse(response?.data?.topics?.isEmpty ?? true)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }
    
    func test_tag_suggestion_ok() {
        let exp = expectation(description: "should finish request")
        
        LamaApi.tagSuggestion() { (response, error) in
            exp.fulfill()
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.data)
            XCTAssertFalse(response?.data?.suggestion?.isEmpty ?? true)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }
}
