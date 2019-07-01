//
//  Constants.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 20/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Default {
        static let animationDuration: TimeInterval = 0.3
        static let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        static let font: UIFont = UIFont.systemFont(ofSize: 14)
        static let itemSpacing: CGFloat = 6
        static let rowSpacing: CGFloat = 6
        static let textFieldCellMinWidth: CGFloat = 60
        static let labelTextColor: UIColor = .darkText
        static let textFieldTextColor: UIColor = .darkText
        static let defaultTokenTopBottomPadding: CGFloat = 4
        static let defaultTokenLeftRightPadding: CGFloat = 8
        static let defaultTokenCellConfiguration: DefaultTokenCellConfiguration = DefaultTokenCellInitialConfiguration()
    }
    
    struct Identifier {
        static let labelCell: String = "ResizingTokenFieldLabelCell"
        static let tokenCell: String = "ResizingTokenFieldTokenCell"
        static let textFieldCell: String = "ResizingTokenFieldTextFieldCell"
    }
    
}

private struct DefaultTokenCellInitialConfiguration: DefaultTokenCellConfiguration {
    func cornerRadius(forSelected isSelected: Bool) -> CGFloat {
        return 8
    }
    
    func borderWidth(forSelected isSelected: Bool) -> CGFloat {
        return 0
    }
    
    func borderColor(forSelected isSelected: Bool) -> CGColor {
        return UIColor.black.cgColor
    }
    
    func textColor(forSelected isSelected: Bool) -> UIColor {
        return .darkText
    }
    
    func backgroundColor(forSelected isSelected: Bool) -> UIColor {
        return isSelected ? UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1) : UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
}
