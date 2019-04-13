//
//  RealMangaEdenApiTests.swift
//  mangaReaderTests
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import XCTest
@testable import mangaReader

class RealMangaEdenApiTests: XCTestCase {

    func test_getTopMangaList() {
        let exp = expectation(description: "should finish request")
        RealMangaEdenApi.getMangaList(pageNumber: 0, pageSize: 30){ (manga, error) in
            exp.fulfill()
            XCTAssertNotNil(manga)
            XCTAssertNotNil(manga?.first)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }
    
    func test_getTopManga() {
        let exp = expectation(description: "should finish request")
        
        let mangaId = "5bfdd0ff719a162b3c196677"
        RealMangaEdenApi.getMangaDetail(mangaId: mangaId) { (manga, error) in
            exp.fulfill()
            XCTAssertNotNil(manga)
            XCTAssertNotNil(manga?.mangaId)
            XCTAssertEqual(manga!.mangaId, mangaId)
            XCTAssertNil(error)
        }
        
        wait(for: [exp], timeout: 30)
    }

}
