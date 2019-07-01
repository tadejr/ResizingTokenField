//
//  Tokens.swift
//  ResizingTokenFieldTests
//
//  Created by Tadej Razborsek on 24/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit
@testable import ResizingTokenField

class MockClassToken: ResizingTokenFieldToken, Equatable, CustomDebugStringConvertible {
    
    static func == (lhs: MockClassToken, rhs: MockClassToken) -> Bool {
        return lhs === rhs
    }
    
    var title: String
    
    var debugDescription: String {
        return "MockClassToken '\(title)'"
    }
    
    init(title: String) {
        self.title = title
    }
}

struct MockStructToken: ResizingTokenFieldToken, Equatable, CustomDebugStringConvertible {
    
    var title: String
    
    var debugDescription: String {
        return "MockStructToken '\(title)'"
    }
    
    init(title: String) {
        self.title = title
    }
    
}

class MockTokens {
    
    static func generateClassTokens(count: Int) -> [MockClassToken] {
        var tokens: [MockClassToken] = []
        for i in 0..<count {
            tokens.append(MockClassToken(title: "Mock Class Token \(i)"))
        }
        
        return tokens
    }
    
    static func generateStructTokens(count: Int) -> [MockStructToken] {
        var tokens: [MockStructToken] = []
        for i in 0..<count {
            tokens.append(MockStructToken(title: "Mock Struct Token \(i)"))
        }
        
        return tokens
    }
    
}
