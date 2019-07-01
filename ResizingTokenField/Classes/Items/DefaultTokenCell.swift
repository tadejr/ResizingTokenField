//
//  DefaultTokenCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

public protocol DefaultTokenCellConfiguration {
    func cornerRadius(forSelected isSelected: Bool) -> CGFloat
    func borderWidth(forSelected isSelected: Bool) -> CGFloat
    func borderColor(forSelected isSelected: Bool) -> CGColor
    func textColor(forSelected isSelected: Bool) -> UIColor
    func backgroundColor(forSelected isSelected: Bool) -> UIColor
}

class DefaultTokenCell: ResizingTokenFieldTokenCell {
    
    static func width(forToken token: ResizingTokenFieldToken, font: UIFont) -> CGFloat {
        let titleWidth = token.title.size(withAttributes: [.font: font]).width
        return ceil(titleWidth) + 2 * Constants.Default.defaultTokenLeftRightPadding  // Leading + title + trailing
    }
    
    let titleLabel: UILabel = UILabel(frame: .zero)
    var configuration: DefaultTokenCellConfiguration = Constants.Default.defaultTokenCellConfiguration {
        didSet { configureWithCurrentConfiguration() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        configureWithCurrentConfiguration()
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Configuration
    
    private func configureWithCurrentConfiguration() {
        layer.cornerRadius = configuration.cornerRadius(forSelected: isSelected)
        layer.borderWidth = configuration.borderWidth(forSelected: isSelected)
        layer.borderColor = configuration.borderColor(forSelected: isSelected)
        backgroundColor = configuration.backgroundColor(forSelected: isSelected)
        titleLabel.textColor = configuration.textColor(forSelected: isSelected)
    }
    
    // MARK: - TokenCellItem

    override func populate(withToken token: ResizingTokenFieldToken) {
        titleLabel.text = token.title
    }
    
    override var isSelected: Bool {
        didSet { configureWithCurrentConfiguration() }
    }
    
}
