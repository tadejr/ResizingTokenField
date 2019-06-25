//
//  LabelCell.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 24/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {
    
    static let identifier: String = "ResizingTokenFieldLabelCell"
    
    let label: UILabel = UILabel(frame: .zero)
    
    static func width(forText text: String?, font: UIFont) -> CGFloat {
        guard let text = text else { return 0 }
        let textWidth = text.size(withAttributes: [.font: font]).width
        return ceil(textWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLabel()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
    }
    
    private func setUpLabel() {
        addSubview(label)
        
        backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
