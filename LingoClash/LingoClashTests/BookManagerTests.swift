//
//  DataManagerTests.swift
//  LingoClashTests
//
//  Created by Kyle キラ on 31/3/22.
//

import XCTest
import PromiseKit

@testable import LingoClashDev

class BookManagerTests: XCTestCase {

//    private static let bookManager = BookManager()
//    private static let authProvider = AppConfigs.API.authProvider
//    private static let testAccountCredentials = LoginFields(
//        email: "test@lingoclash.com", password: "simplepassword")
//
//    override class func setUp() {
//        DispatchQueue.main.async {
//            firstly {
//                authProvider.login(params: testAccountCredentials)
//            }.catch { error in
//                XCTFail(error.localizedDescription)
//            }
//        }
//    }
//
//    override class func tearDown() {
//        DispatchQueue.main.async {
//            firstly {
//                authProvider.logout()
//            }.catch { error in
//                XCTFail(error.localizedDescription)
//            }
//        }
//    }
//
//    func test_getList() {
//
//        let responseExpectation = expectation(description: "response")
//
//        DispatchQueue.main.async {
//            let _ = firstly {
//                BookManagerTests.bookManager.getList()
//            }.done { result in
//                XCTAssertGreaterThan(result.count, 0)
//                responseExpectation.fulfill()
//            }.catch { error in
//                XCTFail(error.localizedDescription)
//            }
//        }
//
//        let result = XCTWaiter.wait(for: [responseExpectation], timeout: 15)
//
//        XCTAssertEqual(result, .completed)
//    }
//
//    func test_getOne() {
//
//        let responseExpectation = expectation(description: "response")
//
//        let bookId = "1"
//
//        DispatchQueue.main.async {
//
//            let _ = firstly {
//                BookManagerTests.bookManager.getOne(id: bookId)
//            }.done { result in
//                XCTAssertEqual(result.id, bookId)
//                responseExpectation.fulfill()
//            }.catch { error in
//                XCTFail(error.localizedDescription)
//            }
//        }
//
//        let result = XCTWaiter.wait(for: [responseExpectation], timeout: 15)
//
//        XCTAssertEqual(result, .completed)
//    }
//
//    func test_getMany() {
//
//        let responseExpectation = expectation(description: "response")
//
//        let bookIds = ["1", "2"]
//
//        DispatchQueue.main.async {
//            let _ = firstly {
//                BookManagerTests.bookManager.getMany(ids: bookIds)
//            }.done { result in
//                XCTAssertEqual(result.count, 2)
//                responseExpectation.fulfill()
//            }.catch { error in
//                XCTFail(error.localizedDescription)
//            }
//        }
//
//        let result = XCTWaiter.wait(for: [responseExpectation], timeout: 15)
//
//        XCTAssertEqual(result, .completed)
//    }
//
//
//    func test_getManyReference() {
//        let responseExpectation = expectation(description: "response")
//
//        let categoryId = "2"
//
//        DispatchQueue.main.async {
//            let _ = firstly {
//                BookManagerTests.bookManager.getManyReference(target: "category_id", id: categoryId)
//            }.done { result in
//                XCTAssertGreaterThan(result.count, 0)
//                responseExpectation.fulfill()
//            }.catch { error in
//                XCTFail(error.localizedDescription)
//            }
//        }
//
//        let result = XCTWaiter.wait(for: [responseExpectation], timeout: 15)
//
//        XCTAssertEqual(result, .completed)
//    }
}
