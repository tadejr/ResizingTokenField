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
        static let itemSpacing: CGFloat = 10
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
        return 5
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
        return isSelected ? .gray : .lightGray
    }
}
