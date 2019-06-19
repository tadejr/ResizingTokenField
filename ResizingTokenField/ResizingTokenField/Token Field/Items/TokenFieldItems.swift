//
//  TokenCellRepresentable.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

protocol TokenCellItem {
    
    /// Returns size of an item for a particular token.
    /// Implementation should use data in the provided token to determine its size.
    static func size(forToken token: ResizingTokenFieldToken) -> CGSize
    
    /// Configure item for the provided token.
    func populate(withToken token: ResizingTokenFieldToken)
    
}
