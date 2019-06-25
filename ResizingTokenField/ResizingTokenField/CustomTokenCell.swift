//
//  CustomTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razboršek on 25/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class CustomTokenCell: ResizingTokenFieldTokenCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    static let titleFont = UIFont.systemFont(ofSize: 15)
    static let subtitleFont = UIFont.systemFont(ofSize: 11)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = CustomTokenCell.titleFont
        subtitleLabel.font = CustomTokenCell.subtitleFont
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }
    
    override var isSelected: Bool {
        didSet { backgroundColor = isSelected ? .lightGray : .clear }
    }
    
    override func populate(withToken token: ResizingTokenFieldToken) {
        if let token = token as? CustomTokenCellViewController.Token {
            titleLabel.text = token.title
            subtitleLabel.text = token.subtitle
        }
    }

}
