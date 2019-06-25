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
    
    struct LabelCell {
        static let isShownByDefault: Bool = false
    }
    
    struct TextFieldCell {
        static let minWidth: CGFloat = 60
    }
    
    struct Duration {
        static let reloadDelay: TimeInterval = 0.1
        static let animationDefault: TimeInterval = 0.3
    }
    
    struct Identifier {
        static let labelCell: String = "ResizingTokenFieldLabelCell"
        static let tokenCell: String = "ResizingTokenFieldTokenCell"
        static let textFieldCell: String = "ResizingTokenFieldTextFieldCell"
    }
    
}
