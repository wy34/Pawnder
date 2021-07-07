//
//  LoginViewModelTests.swift
//  Paw_nderTests
//
//  Created by William Yeung on 6/27/21.
//

import XCTest
@testable import Paw_nder

class LoginViewModelTests: XCTestCase {
    
    var sut: LoginViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = LoginViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testEmptyInitialValues() {
        XCTAssertEqual(sut.email, "")
        XCTAssertEqual(sut.password, "")
    }

}
