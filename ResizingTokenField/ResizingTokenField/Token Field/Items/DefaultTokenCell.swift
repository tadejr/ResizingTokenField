//
//  DefaultTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class DefaultTokenCell: ResizingTokenFieldTokenCell {
    
    static let identifier: String = "ResizingTokenFieldDefaultTokenCell"
    
    let titleLabel: UILabel = UILabel(frame: .zero)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
        backgroundColor = .white
    }
    
    private func setUpLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
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
