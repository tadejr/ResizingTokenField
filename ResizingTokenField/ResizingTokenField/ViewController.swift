//
//  ViewController.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class Token: ResizingTokenFieldToken, Equatable {
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs === rhs
    }
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tokenField: ResizingTokenField!
    @IBOutlet weak var animateSwitch: UISwitch!
    
    private lazy var titles: [String] = {
        "Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elit".components(separatedBy: " ")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenField.labelText = "These are some tokens:"
        let tokens: [Token] = [
            Token(title: "Lorem"),
            Token(title: "Ipsum"),
            Token(title: "Dolor")
        ]
        
        tokenField.append(tokens: tokens)
    }
    
    // MARK: - IB actions
    
    @IBAction func didTapAddTokenButton(_ sender: UIButton) {
        tokenField.append(tokens: [Token(title: getRandomTitle())], animated: animateSwitch.isOn, completion: nil)
    }
    
    @IBAction func didTapAddMultipleTokensButton(_ sender: UIButton) {
        var tokens: [Token] = []
        for _ in 0...(Int(arc4random_uniform(5))) {
            tokens.append(Token(title: getRandomTitle()))
        }

        tokenField.append(tokens: tokens, animated: animateSwitch.isOn, completion: nil)
    }
    
    @IBAction func didTapToggleLabelButton(_ sender: UIButton) {
        tokenField.isShowingLabel ? tokenField.hideLabel(animated: animateSwitch.isOn, completion: nil) : tokenField.showLabel(animated: animateSwitch.isOn, completion: nil)
    }
    
    // MARK: - Rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tokenField.handleOrientationChange()
    }
    
    // MARK: - Helpers
    
    private func getRandomTitle() -> String {
        return titles[Int(arc4random_uniform(UInt32(titles.count)))]
    }
    
}

