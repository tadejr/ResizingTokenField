//
//  TextFieldCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class TextFieldCell: UICollectionViewCell {
    
    static let identifier: String = "TextFieldCell"
    
    /// Implement to handle text field changes.
    var onTextFieldEditingChanged: ((String?) -> Void)?
    
    let textField: UITextField
    
    required init?(coder aDecoder: NSCoder) {
        self.textField = UITextField(frame: CGRect.zero)
        super.init(coder: aDecoder)
        setUpTextField()
    }
    
    override init(frame: CGRect) {
        self.textField = UITextField(frame: CGRect.zero)
        super.init(frame: frame)
        setUpTextField()
    }
    
    private func setUpTextField() {
        addSubview(textField)
        
        backgroundColor = .gray
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    // MARK: - First responder
    
    override var canBecomeFirstResponder: Bool {
        return textField.canBecomeFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: - Handling text field changes
    
    @objc func textFieldEditingChanged(textField: UITextField) {
        if textField == self.textField {
            onTextFieldEditingChanged?(textField.text)
        }
    }
    
}
