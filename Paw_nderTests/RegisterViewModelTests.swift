//
//  RegisterViewModelTests.swift
//  Paw_nderTests
//
//  Created by William Yeung on 6/27/21.
//

import XCTest
@testable import Paw_nder

class RegisterViewModelTests: XCTestCase {

    var sut: RegisterViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = RegisterViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testEmptyInitalValues() {
        XCTAssertEqual(sut.fullName, "")
        XCTAssertEqual(sut.email, "")
        XCTAssertEqual(sut.password, "")
        XCTAssertNil(sut.gender)
    }
}
