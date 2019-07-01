//
//  ResizingTokenFieldToken.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import Foundation

public protocol ResizingTokenFieldToken {
    
    /// Title displayed on the token.
    var title: String { get }
    
    /// Equality check. Protocol adopter can conform to `Equatable` instead of implementing this.
    func isEqual(to token: ResizingTokenFieldToken) -> Bool
    
}

public extension ResizingTokenFieldToken where Self: Equatable {
    
    func isEqual(to token: ResizingTokenFieldToken) -> Bool {
        guard let token = token as? Self else { return false }
        return self == token
    }
    
}
