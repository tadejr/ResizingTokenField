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
    
    /// Called when cell should be removed due to user tapping a key while this cell is the first responder.
    var onShouldBeRemoved: ((_ replacementText: String?) -> Void)?
    
    /// Called when token cell is asked to resign first responder.
    var onResignFirstResponder: ((_ isBeingRemoved: Bool) -> Void)?
    
    /// Set to `true` while this cell is asking if it should be removed.
    var isBeingRemoved: Bool = false
    
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
        onResignFirstResponder?(isBeingRemoved)
        return true
    }
    
    // MARK: - UIKeyInput
    
    public var hasText: Bool {
        return false
    }
    
    public func insertText(_ text: String) {
        isBeingRemoved = true
        onShouldBeRemoved?(text)
        isBeingRemoved = false
    }
    
    public func deleteBackward() {
        isBeingRemoved = true
        onShouldBeRemoved?(nil)
        isBeingRemoved = false
    }
    
}
