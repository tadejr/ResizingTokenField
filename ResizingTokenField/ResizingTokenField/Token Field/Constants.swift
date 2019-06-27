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
    
    struct Default {
        static let animationDuration: TimeInterval = 0.3
        static let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        static let font: UIFont = UIFont.systemFont(ofSize: 15)
        static let textFieldCellMinWidth: CGFloat = 60
    }
    
    struct Identifier {
        static let labelCell: String = "ResizingTokenFieldLabelCell"
        static let tokenCell: String = "ResizingTokenFieldTokenCell"
        static let textFieldCell: String = "ResizingTokenFieldTextFieldCell"
    }
    
}
