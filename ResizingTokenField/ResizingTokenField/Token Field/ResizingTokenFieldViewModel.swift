//
//  ResizingTokenFieldViewModel.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class ResizingTokenFieldViewModel {
    var tokens: [ResizingTokenFieldToken] = []
    
    func token(atIndexPath indexPath: IndexPath) -> ResizingTokenFieldToken? {
        guard tokens.count > indexPath.item else { return nil }
        
        return tokens[indexPath.item]
    }
    
}
