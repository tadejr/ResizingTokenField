//
//  TokenCellRepresentable.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class ResizingTokenFieldTokenCell: UICollectionViewCell, UIKeyInput {
    
    /// Returns width of an item for a particular token.
    class func width(forToken token: ResizingTokenFieldToken, font: UIFont) -> CGFloat {
        // Override.
        return 0
    }
    
    /// Called when this token cell should be removed, usually due to user tapping backspace.
    var onRemove: ((String?) -> Void)?
    
    /// Configure item for the provided token and font.
    func populate(withToken token: ResizingTokenFieldToken, font: UIFont) {
        // Override.
    }
    
    // MARK: UIResponder
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override var canResignFirstResponder: Bool { return true }
    
    override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() else { return false }
        isSelected = true
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() else { return false }
        isSelected = false
        return true
    }
    
    // MARK: - UIKeyInput
    
    var hasText: Bool {
        return false
    }
    
    func insertText(_ text: String) {
        onRemove?(text)
    }
    
    func deleteBackward() {
        onRemove?(nil)
    }
    
}
