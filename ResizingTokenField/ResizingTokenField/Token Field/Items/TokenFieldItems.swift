//
//  TokenCellRepresentable.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

protocol TokenCellItem {
    
    /// Returns width of an item for a particular token.
    static func width(forToken token: ResizingTokenFieldToken, font: UIFont) -> CGFloat
    
    /// Configure item for the provided token and font.
    func populate(withToken token: ResizingTokenFieldToken, font: UIFont)
}
