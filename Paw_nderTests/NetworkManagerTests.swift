//
//  NetworkManagerTests.swift
//  Paw_nderTests
//
//  Created by William Yeung on 6/27/21.
//

import XCTest
@testable import Paw_nder

class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testCanParseDogBreedData() {
        let json = """
            [
                {
                    "weight": {
                        "imperial": "5 - 10",
                        "metric": "2 - 5"
                    },
                    "height": {
                        "imperial": "10",
                        "metric": "25"
                    },
                    "id": 249,
                    "name": "Toy Poodle",
                    "breed_group": "Toy",
                    "life_span": "14 - 18 years"
                }
            ]
        """
        
        let data = json.data(using: .utf8)!
        let breed = try! JSONDecoder().decode([Breed].self, from: data)
        
        XCTAssertEqual(breed[0].name, "Toy Poodle")
    }
}
