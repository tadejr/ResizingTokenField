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
    static let titleTextStyle: UIFont.TextStyle = .body
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: DefaultTokenCell.titleTextStyle)
    }
    
    // MARK: - TokenCellItem
    
    static func size(forToken token: ResizingTokenFieldToken) -> CGSize {
        let titleSize = token.title.size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: DefaultTokenCell.titleTextStyle)])
        return CGSize(width: 4 + ceil(titleSize.width) + 4,  // Leading + title + trailing
                      height: 4 + ceil(titleSize.height) + 4)   // Top + height + bottom
    }
    
    func populate(withToken token: ResizingTokenFieldToken) {
        titleLabel.text = token.title
    }

}
