//
//  ResizingTokenFieldTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

open class ResizingTokenFieldTokenCell: UICollectionViewCell, UIKeyInput {
    
    /// Configure item for the provided token and font.
    open func populate(withToken token: ResizingTokenFieldToken) {
        // Override.
    }
    
    /// Called when this token cell should be removed, usually due to user tapping backspace.
    var onRemove: ((String?) -> Void)?
    
    
    // MARK: UIResponder
    
    private(set) var isBecomingFirstResponder: Bool = false
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override var canResignFirstResponder: Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        isBecomingFirstResponder = true
        super.becomeFirstResponder()
        isBecomingFirstResponder = false
        isSelected = true
        return true
    }
    
    open override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        isBecomingFirstResponder = false
        isSelected = false
        return true
    }
    
    // MARK: - UIKeyInput
    
    public var hasText: Bool {
        return false
    }
    
    public func insertText(_ text: String) {
        onRemove?(text)
    }
    
    public func deleteBackward() {
        onRemove?(nil)
    }
    
}
