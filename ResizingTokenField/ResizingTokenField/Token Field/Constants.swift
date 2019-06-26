//
//  Constants.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 20/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Font {
        static let defaultFont: UIFont = UIFont.systemFont(ofSize: 15)
    }
    
    struct Content {
        static let defaultInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    struct LabelCell {
        static let isShownByDefault: Bool = true
    }
    
    struct TextFieldCell {
        static let defaultMinWidth: CGFloat = 60
    }
    
    struct Duration {
        static let animationDefault: TimeInterval = 0.3
    }
    
    struct Identifier {
        static let labelCell: String = "ResizingTokenFieldLabelCell"
        static let tokenCell: String = "ResizingTokenFieldTokenCell"
        static let textFieldCell: String = "ResizingTokenFieldTextFieldCell"
    }
    
}
