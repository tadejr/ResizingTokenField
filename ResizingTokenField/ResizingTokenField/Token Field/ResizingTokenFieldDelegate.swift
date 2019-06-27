//
//  ResizingTokenFieldDelegate.swift
//  ResizingTokenField
//
//  Created by Tadej Razboršek on 25/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

protocol ResizingTokenFieldDelegate: AnyObject {
    
    /// Called when token field text is edited.
    /// Also invoked if text is changed via the ResizingTokenField `text` property.
    ///
    /// - Parameters:
    ///   - tokenField: Token field.
    ///   - newText: New text in the token field.
    func resizingTokenField(_ tokenField: ResizingTokenField, didEditText newText: String?)
    
    /// Return `true` to confirm removal of `token`. This will only be called when tokens are removed by internal logic.
    /// For example, if user taps backspace while a token is selected.
    ///
    /// - Parameters:
    ///   - tokenField: Token field from which a token is being removed.
    ///   - token: Token being removed.
    /// - Returns: Boolean value indicating if `token` can be removed.
    func resizingTokenField(_ tokenField: ResizingTokenField, shouldRemoveToken token: ResizingTokenFieldToken) -> Bool
    
    
    /// Return `true` to allow the token field to collapse tokens.
    /// This is called when token field editing ends.
    ///
    /// - Parameter tokenField: Token field wanting to collapse tokens.
    /// - Returns: Boolean value indicating if tokens can be collapsed.
    func resizingTokenFieldShouldCollapseTokens(_ tokenField: ResizingTokenField) -> Bool
    
    /// Text for collapsed tokens.
    ///
    /// - Parameter tokenField: Token field showing the text.
    /// - Returns: Text to show instead of the collapsed tokens.
    func resizingTokenFieldCollapsedTokensText(_ tokenField: ResizingTokenField) -> String?
    
}

/// Implement to provide custom cells for tokens.
protocol ResizingTokenFieldCustomCellDelegate: AnyObject {
    
    /// Returns a custom token cell class to register. Either this or `resizingTokenFieldCustomTokenCellNib(:)` must return a non-nil value.
    ///
    /// - Parameter tokenField: The token field.
    /// - Returns: Class for the custom token cell.
    func resizingTokenFieldCustomTokenCellClass(_ tokenField: ResizingTokenField) -> ResizingTokenFieldTokenCell.Type?
    
    /// Returns a custom token cell nib to register. Either this or `resizingTokenFieldCustomTokenCellClass(:)` must return a non-nil value.
    ///
    /// - Parameter tokenField: The token field.
    /// - Returns: Nib for the custom token cell.
    func resizingTokenFieldCustomTokenCellNib(_ tokenField: ResizingTokenField) -> UINib?
    
    /// Returns width of a token cell for a particular token.
    /// Used for the collection view cell size. Height provided by ResizingTokenField `itemHeight` property.
    ///
    /// - Parameters:
    ///   - tokenField: The token field.
    ///   - token: A token field token.
    /// - Returns: Width of the custom token cell for the provided token.
    func resizingTokenField(_ tokenField: ResizingTokenField, tokenCellWidthForToken token: ResizingTokenFieldToken) -> CGFloat
    
}
