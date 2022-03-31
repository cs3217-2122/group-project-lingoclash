//
//  DataManagerTests.swift
//  LingoClashTests
//
//  Created by Kyle キラ on 31/3/22.
//

import XCTest
import PromiseKit

@testable import LingoClash


/*
 login then test;
 login to this account and test his account;
 
 */
class BookManagerTests: XCTestCase {
    
    private static let bookManager = BookManager()
    private static let authProvider = FirebaseAuthProvider()
    private static let credentials = [
        "email": "test@testing.com",
        "password": "testing"
    ]
    
    override class func setUp() {
        DispatchQueue.main.async {
            firstly {
                authProvider.login(params: credentials)
            }.catch { error in
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    override class func tearDown() {
        DispatchQueue.main.async {
            firstly {
                authProvider.logout()
            }.catch { error in
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_getList() {
        
        let responseExpectation = expectation(description: "response")
        
        DispatchQueue.main.async {
            let _ = firstly {
                BookManagerTests.bookManager.getList()
            }.done { result in
                XCTAssertGreaterThan(result.count, 0)
                responseExpectation.fulfill()
            }.catch { error in
                XCTFail(error.localizedDescription)
            }
        }
        
        let result = XCTWaiter.wait(for: [responseExpectation], timeout: 30)
        
        XCTAssertEqual(result, .completed)
    }
    
    func test_getOne() {
        
        let responseExpectation = expectation(description: "response")
        
        let bookId = "1"
        
        DispatchQueue.main.async {
            
            let _ = firstly {
                BookManagerTests.bookManager.getOne(id: bookId)
            }.done { result in
                XCTAssertEqual(result.id, bookId)
                responseExpectation.fulfill()
            }.catch { error in
                XCTFail(error.localizedDescription)
            }
        }
        
        let result = XCTWaiter.wait(for: [responseExpectation], timeout: 30)
        
        XCTAssertEqual(result, .completed)
    }
}
