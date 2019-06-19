//
//  ViewController.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class Token: ResizingTokenFieldToken {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tokenField: ResizingTokenField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tokens: [Token] = [
            Token(title: "Lorem"),
            Token(title: "Ipsum"),
            Token(title: "Dolor")
        ]
        
        tokenField.appendTokens(tokens, animated: false)
    }


}

