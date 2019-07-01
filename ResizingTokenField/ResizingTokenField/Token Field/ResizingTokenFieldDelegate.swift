//
//  ResizingTokenFieldDelegate.swift
//  ResizingTokenField
//
//  Created by Tadej Razboršek on 25/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

protocol ResizingTokenFieldDelegate: AnyObject {
    
    /// Return `true` to allow the token field to collapse tokens.
    /// This is called when token field editing ends.
    /// Required.
    ///
    /// - Parameter tokenField: Token field wanting to collapse tokens.
    /// - Returns: Boolean value indicating if tokens can be collapsed.
    func resizingTokenFieldShouldCollapseTokens(_ tokenField: ResizingTokenField) -> Bool
    
    /// Text for collapsed tokens.
    /// Required.
    ///
    /// - Parameter tokenField: Token field showing the text.
    /// - Returns: Text to show instead of the collapsed tokens.
    func resizingTokenFieldCollapsedTokensText(_ tokenField: ResizingTokenField) -> String?
    
    /// Called when token field is about to change its height constraint constant.
    /// Optional.
    ///
    /// - Parameters:
    ///   - tokenField: Token field changing the height constraint constant.
    ///   - newHeight: New height.
    func resizingTokenField(_ tokenField: ResizingTokenField, willChangeHeight newHeight: CGFloat)
    
    /// Called after token field updates its height constraint constant.
    /// Optional.
    ///
    /// - Parameters:
    ///   - tokenField: Token field changing the height constraint constant.
    ///   - newHeight: New height.
    func resizingTokenField(_ tokenField: ResizingTokenField, didChangeHeight newHeight: CGFloat)
    
    /// Called when token field text is edited.
    /// Also invoked if text is changed via the ResizingTokenField `text` property.
    /// Optional.
    ///
    /// - Parameters:
    ///   - tokenField: Token field.
    ///   - newText: New text in the token field.
    func resizingTokenField(_ tokenField: ResizingTokenField, didEditText newText: String?)
    
    /// Return `true` to confirm removal of `token`. This will only be called when tokens are removed by internal logic.
    /// For example, if user taps backspace while a token is selected.
    /// Optional. Default implementation always returns `true`
    ///
    /// - Parameters:
    ///   - tokenField: Token field from which a token is being removed.
    ///   - token: Token being removed.
    /// - Returns: Boolean value indicating if `token` can be removed.
    func resizingTokenField(_ tokenField: ResizingTokenField, shouldRemoveToken token: ResizingTokenFieldToken) -> Bool
    
    /// Return configuration for a default token cell or `nil` to use default configuration.
    /// Not called if custom token cells are used.
    /// Optional.
    ///
    /// - Parameters:
    ///   - tokenField: Token field showing the cell.
    ///   - token: Token represented by the cell.
    /// - Returns: Configuration of the cell.
    func resizingTokenField(_ tokenField: ResizingTokenField, configurationForDefaultCellRepresenting token: ResizingTokenFieldToken) -> DefaultTokenCellConfiguration?
    
}

/// Default implementations for optional methods.
extension ResizingTokenFieldDelegate {
    
    func resizingTokenField(_ tokenField: ResizingTokenField, willChangeHeight newHeight: CGFloat) {}
    func resizingTokenField(_ tokenField: ResizingTokenField, didChangeHeight newHeight: CGFloat) {}
    func resizingTokenField(_ tokenField: ResizingTokenField, didEditText newText: String?) {}
    func resizingTokenField(_ tokenField: ResizingTokenField, shouldRemoveToken token: ResizingTokenFieldToken) -> Bool { return true }
    func resizingTokenField(_ tokenField: ResizingTokenField, configurationForDefaultCellRepresenting token: ResizingTokenFieldToken) -> DefaultTokenCellConfiguration? { return nil }
    
}

/// Implement to provide custom cells for tokens.
protocol ResizingTokenFieldCustomCellDelegate: AnyObject {
    
    /// Returns a custom token cell class to register. Either this or `resizingTokenFieldCustomTokenCellNib(:)` must return a non-nil value.
    /// Required.
    ///
    /// - Parameter tokenField: The token field.
    /// - Returns: Class for the custom token cell.
    func resizingTokenFieldCustomTokenCellClass(_ tokenField: ResizingTokenField) -> ResizingTokenFieldTokenCell.Type?
    
    /// Returns a custom token cell nib to register. Either this or `resizingTokenFieldCustomTokenCellClass(:)` must return a non-nil value.
    /// Required.
    ///
    /// - Parameter tokenField: The token field.
    /// - Returns: Nib for the custom token cell.
    func resizingTokenFieldCustomTokenCellNib(_ tokenField: ResizingTokenField) -> UINib?
    
    /// Returns width of a token cell for a particular token.
    /// Used for the collection view cell size. Height provided by ResizingTokenField `itemHeight` property.
    /// Required.
    ///
    /// - Parameters:
    ///   - tokenField: The token field.
    ///   - token: A token field token.
    /// - Returns: Width of the custom token cell for the provided token.
    func resizingTokenField(_ tokenField: ResizingTokenField, tokenCellWidthForToken token: ResizingTokenFieldToken) -> CGFloat
    
}
