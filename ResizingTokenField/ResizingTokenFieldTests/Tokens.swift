//
//  Tokens.swift
//  ResizingTokenFieldTests
//
//  Created by Tadej Razborsek on 24/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

@testable import ResizingTokenField

class ClassToken: ResizingTokenFieldToken, Equatable, CustomDebugStringConvertible {
    
    static func == (lhs: ClassToken, rhs: ClassToken) -> Bool {
        return lhs === rhs
    }
    
    var title: String
    
    var debugDescription: String {
        return "ClassToken '\(title)'"
    }
    
    init(title: String) {
        self.title = title
    }
}

struct StructToken: ResizingTokenFieldToken, Equatable, CustomDebugStringConvertible {
    
    var title: String
    
    var debugDescription: String {
        return "StructToken '\(title)'"
    }
    
    init(title: String) {
        self.title = title
    }
    
}

class Tokens {
    
    static func generateClassTokens(count: Int) -> [ClassToken] {
        var tokens: [ClassToken] = []
        for i in 0..<count {
            tokens.append(ClassToken(title: "Class Token \(i)"))
        }
        
        return tokens
    }
    
    static func generateStructTokens(count: Int) -> [StructToken] {
        var tokens: [StructToken] = []
        for i in 0..<count {
            tokens.append(StructToken(title: "Struct Token \(i)"))
        }
        
        return tokens
    }
    
}
