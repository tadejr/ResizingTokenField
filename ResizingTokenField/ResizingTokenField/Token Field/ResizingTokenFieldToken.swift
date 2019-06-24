//
//  ResizingTokenFieldToken.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import Foundation

protocol ResizingTokenFieldToken {
    
    /// Title displayed on the token.
    var title: String { get }
    
    /// Equality check.
    func isEqual(to token: ResizingTokenFieldToken) -> Bool
    
}

// To avoid having to use generics with ResizingTokenField (which cause issues when used in IB), use a type erasure wrapper.

//struct AnyResizingTokenFieldToken: Equatable {
//
//    // MARK: - Equatable
//
//    static func == (lhs: AnyResizingTokenFieldToken, rhs: AnyResizingTokenFieldToken) -> Bool {
//        return lhs.token.isEqual(to: rhs.token)
//    }
//
//    // MARK: - Type erasure
//
//    private let token: ResizingTokenFieldToken
//
//    init(_ token: ResizingTokenFieldToken) {
//        self.token = token
//    }
//
//}
//
//extension ResizingTokenFieldToken {
//
//    func asAny() -> AnyResizingTokenFieldToken {
//        return AnyResizingTokenFieldToken(self)
//    }
//
//}

extension ResizingTokenFieldToken where Self: Equatable {
    
    func isEqual(to token: ResizingTokenFieldToken) -> Bool {
        guard let token = token as? Self else { return false }
        return self == token
    }
    
}
