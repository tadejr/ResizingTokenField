//
//  ResizingTokenFieldDelegate.swift
//  ResizingTokenField
//
//  Created by Tadej Razboršek on 25/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

protocol ResizingTokenFieldDelegate: AnyObject {
    
    
    func resizingTokenField(_ tokenField: ResizingTokenField, didEditText newText: String?)
    
    /// Return true to confirm removal of `token`. This will only be called when tokens are removed by internal logic.
    /// For example, if user taps backspace while a token is selected.
    ///
    /// - Parameters:
    ///   - tokenField: Token field from which a token is being removed.
    ///   - token: Token being removed.
    /// - Returns: Boolean value indicating if `token` can be removed.
    func resizingTokenField(_ tokenField: ResizingTokenField, shouldRemoveToken token: ResizingTokenFieldToken) -> Bool
    
}

protocol ResizingTokenFieldCustomCellDelegate: AnyObject {
    func resizingTokenFieldCustomTokenCellClass(_ tokenField: ResizingTokenField) -> ResizingTokenFieldTokenCell.Type?
    func resizingTokenFieldCustomTokenCellNib(_ tokenField: ResizingTokenField) -> UINib?
    func resizingTokenField(_ tokenField: ResizingTokenField, tokenCellWidthForToken token: ResizingTokenFieldToken) -> CGFloat
}
