//
//  DefaultTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class DefaultTokenCell: UICollectionViewCell, TokenCellItem {
    
    static let nibName: String = "DefaultTokenCell"
    static let identifier: String = "DefaultTokenCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - TokenCellItem
    static func width(forToken token: ResizingTokenFieldToken, font: UIFont) -> CGFloat {
        let titleWidth = token.title.size(withAttributes: [.font: font]).width
        return 4 + ceil(titleWidth) + 4  // Leading + title + trailing
    }

    func populate(withToken token: ResizingTokenFieldToken, font: UIFont) {
        titleLabel.font = font
        titleLabel.text = token.title
    }
}
