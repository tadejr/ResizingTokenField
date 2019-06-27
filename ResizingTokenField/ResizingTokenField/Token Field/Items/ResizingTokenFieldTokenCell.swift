//
//  ResizingTokenFieldTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class ResizingTokenFieldTokenCell: UICollectionViewCell, UIKeyInput {
    
    /// Configure item for the provided token and font.
    func populate(withToken token: ResizingTokenFieldToken) {
        // Override.
    }
    
    /// Called when this token cell should be removed, usually due to user tapping backspace.
    var onRemove: ((String?) -> Void)?
    
    
    // MARK: UIResponder
    
    private(set) var isBecomingFirstResponder: Bool = false
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        isBecomingFirstResponder = true
        super.becomeFirstResponder()
        isBecomingFirstResponder = false
        isSelected = true
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        isBecomingFirstResponder = false
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
