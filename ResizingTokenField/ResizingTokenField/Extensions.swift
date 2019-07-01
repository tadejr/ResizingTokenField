//
//  Extensions.swift
//  ResizingTokenField
//
//  Created by Tadej Razboršek on 25/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

extension String {
    
    func width(withFont font: UIFont) -> CGFloat {
        return ceil(self.size(withAttributes: [.font: font]).width)
    }
    
}

extension UIViewController {
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let newHeight = view.convert(keyboardFrame.cgRectValue, from: nil).size.height - view.safeAreaInsets.bottom
        keyboardVisibleHeightWillChange(newHeight: newHeight)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        keyboardVisibleHeightWillChange(newHeight: 0)
    }
    
    @objc func keyboardVisibleHeightWillChange(newHeight: CGFloat) {}
    
}
