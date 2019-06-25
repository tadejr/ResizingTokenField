//
//  ResizingTokenFieldDelegates.swift
//  ResizingTokenField
//
//  Created by Tadej Razboršek on 25/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

protocol ResizingTokenFieldDelegate: AnyObject {
    
    func resizingTokenField(_ tokenField: ResizingTokenField, didEditText newText: String?)
    
}

protocol ResizingTokenFieldCustomCellDelegate: AnyObject {
    func resizingTokenFieldCustomTokenCellClass(_ tokenField: ResizingTokenField) -> ResizingTokenFieldTokenCell.Type?
    func resizingTokenFieldCustomTokenCellNib(_ tokenField: ResizingTokenField) -> UINib?
    func resizingTokenField(_ tokenField: ResizingTokenField, tokenCellWidthForToken token: ResizingTokenFieldToken) -> CGFloat
}
