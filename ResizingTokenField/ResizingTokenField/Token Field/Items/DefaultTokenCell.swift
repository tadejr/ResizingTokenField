//
//  DefaultTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class DefaultTokenCell: ResizingTokenFieldTokenCell {
    
    static func width(forToken token: ResizingTokenFieldToken, font: UIFont) -> CGFloat {
        let titleWidth = token.title.size(withAttributes: [.font: font]).width
        return 4 + ceil(titleWidth) + 4  // Leading + title + trailing
    }
    
    let titleLabel: UILabel = UILabel(frame: .zero)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        layer.cornerRadius = 5
        backgroundColor = .lightGray
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - TokenCellItem

    override func populate(withToken token: ResizingTokenFieldToken) {
        titleLabel.text = token.title
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .gray : .lightGray
        }
    }
    
}
