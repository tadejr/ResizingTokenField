//
//  DefaultTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class DefaultTokenCell: ResizingTokenFieldTokenCell {
    
    static let nibName: String = "DefaultTokenCell"
    static let identifier: String = "ResizingTokenFieldDefaultTokenCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - TokenCellItem
    
    override class func width(forToken token: ResizingTokenFieldToken, font: UIFont) -> CGFloat {
        let titleWidth = token.title.size(withAttributes: [.font: font]).width
        return 4 + ceil(titleWidth) + 4  // Leading + title + trailing
    }

    override func populate(withToken token: ResizingTokenFieldToken, font: UIFont) {
        titleLabel.font = font
        titleLabel.text = token.title
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .gray : .white
        }
    }
    
    // MARK: - Autocorrection
    
//    var autocorrectionType: UITextAutocorrectionType = .no
    
}
