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
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - TokenCellItem
    
    func populate(withToken token: ResizingTokenFieldToken) {
        titleLabel.text = token.title
    }

}
