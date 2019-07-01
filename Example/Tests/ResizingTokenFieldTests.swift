//
//  ResizingTokenFieldTests.swift
//  ResizingTokenFieldTests
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import XCTest
@testable import ResizingTokenField

class ResizingTokenFieldTests: XCTestCase {
    
    var tokenField: ResizingTokenField! // SUT
    
    override func setUp() {
        super.setUp()
        tokenField = ResizingTokenField()
    }

    override func tearDown() {
        super.tearDown()
        tokenField = nil
    }
    
    // MARK: - Add/remove tokens

    func testAddRemoveClassTokens() {
        let singleToken = MockClassToken(title: "Single Class Token")
        let multipleTokens = MockTokens.generateClassTokens(count: 5)
        
        tokenField.append(tokens: [singleToken])
        XCTAssert(tokenField.tokens.count == 1, "Adding tokens should increase count correctly.")
        
        tokenField.append(tokens: multipleTokens)
        XCTAssert(tokenField.tokens.count == 6, "Adding tokens should increase count correctly.")
        
        tokenField.remove(tokens: multipleTokens)
        XCTAssert(tokenField.tokens.count == 1, "Removing tokens should decerase count correctly.")
        
        tokenField.remove(tokens: [singleToken])
        XCTAssert(tokenField.tokens.count == 0, "Removing tokens should decerase count correctly.")
    }

    func testAddRemoveStructTokens() {
        let singleToken = MockStructToken(title: "Single Struct Token")
        let multipleTokens = MockTokens.generateStructTokens(count: 5)
        
        tokenField.append(tokens: [singleToken])
        XCTAssert(tokenField.tokens.count == 1, "Adding tokens should increase count correctly.")
        
        tokenField.append(tokens: multipleTokens)
        XCTAssert(tokenField.tokens.count == 6, "Adding tokens should increase count correctly.")
        
        tokenField.remove(tokens: multipleTokens)
        XCTAssert(tokenField.tokens.count == 1, "Removing tokens should decerase count correctly.")
        
        tokenField.remove(tokens: [singleToken])
        XCTAssert(tokenField.tokens.count == 0, "Removing tokens should decerase count correctly.")
    }
    
    func testAddRemoveMixedTokens() {
        let singleClassToken = MockClassToken(title: "Single Class Token")
        let multipleClassTokens = MockTokens.generateClassTokens(count: 5)
        let singleStructToken = MockStructToken(title: "Single Struct Token")
        let multipleStructTokens = MockTokens.generateStructTokens(count: 5)
        
        tokenField.append(tokens: [singleClassToken])
        XCTAssert(tokenField.tokens.count == 1, "Adding tokens should increase count correctly.")
        
        tokenField.append(tokens: [singleStructToken])
        XCTAssert(tokenField.tokens.count == 2, "Adding tokens should increase count correctly.")
        
        tokenField.append(tokens: multipleStructTokens + multipleClassTokens)
        XCTAssert(tokenField.tokens.count == 12, "Adding tokens should increase count correctly.")
        
        tokenField.remove(tokens: multipleStructTokens)
        XCTAssert(tokenField.tokens.count == 7, "Removing tokens should decrease count correctly.")
        
        tokenField.remove(tokens: multipleClassTokens + [singleClassToken])
        XCTAssert(tokenField.tokens.count == 1, "Removing tokens should decrease count correctly.")
        
        let isSingleStructToken: Bool = (tokenField.tokens.first as? MockStructToken) == singleStructToken
        XCTAssert(isSingleStructToken, "The last remaining token should be a MockStructToken.")
        
        tokenField.remove(tokens: [singleStructToken])
        XCTAssert(tokenField.tokens.count == 0, "Removing tokens should decerase count correctly.")
    }
    
    func testInvalidRemoveToken() {
        let singleClassToken1 = MockClassToken(title: "Single Class Token 1")
        let singleClassToken2 = MockClassToken(title: "Single Class Token 2")
        let multipleClassTokens = MockTokens.generateClassTokens(count: 5)
        
        tokenField.append(tokens: multipleClassTokens + [singleClassToken1])
        XCTAssert(tokenField.tokens.count == 6, "Adding tokens should increase count correctly.")
        
        tokenField.remove(tokens: [singleClassToken2])
        XCTAssert(tokenField.tokens.count == 6, "Removing tokens not in the token field should not affect count.")
        
        tokenField.remove(tokens: [singleClassToken2, singleClassToken1])
        XCTAssert(tokenField.tokens.count == 5, "Only removing tokens already in the token field should decrease count.")
    }
    
    func testRemoveTokenAtIndex() {
        let multipleClassTokens = MockTokens.generateClassTokens(count: 5)
        
        tokenField.append(tokens: multipleClassTokens)
        XCTAssert(tokenField.tokens.count == 5, "Adding tokens should increase count correctly.")
        
        tokenField.remove(tokensAtIndexes: [2, 3])
        XCTAssert(tokenField.tokens.count == 3, "Removing tokens should decrease count correctly.")
    }
    
    func testInvalidRemoveTokenAtIndex() {
        let multipleClassTokens = MockTokens.generateClassTokens(count: 5)
        
        tokenField.append(tokens: multipleClassTokens)
        XCTAssert(tokenField.tokens.count == 5, "Adding tokens should increase count correctly.")
        
        tokenField.remove(tokensAtIndexes: [9])
        XCTAssert(tokenField.tokens.count == 5, "Removing tokens at invalid indexes should not affect count.")
        
        tokenField.remove(tokensAtIndexes: [4, 3, 5, 1])
        XCTAssert(tokenField.tokens.count == 2, "Only removing tokens at valid indexes should decrease count.")
    }
    
    func testRemoveAllTokens() {
        let mixedTokens: [ResizingTokenFieldToken] = MockTokens.generateClassTokens(count: 5) + MockTokens.generateStructTokens(count: 5)
        tokenField.append(tokens: mixedTokens)
        XCTAssert(tokenField.tokens.count == 10, "Adding tokens should increase count correctly.")
        
        tokenField.removeAllTokens()
        XCTAssert(tokenField.tokens.count == 0, "Removing all tokens should decrease count to 0.")
    }
    
    func testShowHideLabel() {
        tokenField.showLabel()
        XCTAssert(tokenField.viewModel.numberOfItems == 2, "Token field should have 2 items (label + text field).")
        
        let multipleClassTokens = MockTokens.generateClassTokens(count: 5)
        tokenField.append(tokens: multipleClassTokens)
        XCTAssert(tokenField.viewModel.numberOfItems == 7, "Token field should have 7 items (label + tokens + text field).")
        
        tokenField.hideLabel()
        XCTAssert(tokenField.viewModel.numberOfItems == 6, "Token field should have 6 items (tokens + text field).")
    }

}
