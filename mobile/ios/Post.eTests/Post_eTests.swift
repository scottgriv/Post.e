//
//  Post_eTests.swift
//  Post.eTests
//
//  Created by Scott Grivner on 8/15/22.
//

import XCTest
@testable import Post_e

class Post_eTests: XCTestCase {

    func testSum_TwoNumbers_ReturnsSum() {
        // Arrange (set up the needed objects)
        let myClass = Post()
        
        // Act (run the method you want to test)
        let sum = myClass.sum(a:1,2)
        
        // Assert (test that the behavior is as expected)
        XCTAssertEqual(sum, 3)
        
    }
}
