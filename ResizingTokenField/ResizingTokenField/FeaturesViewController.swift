//
//  FeaturesViewController.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController, UITextFieldDelegate {
    
    class Token: ResizingTokenFieldToken, Equatable {
        
        static func == (lhs: Token, rhs: Token) -> Bool {
            return lhs === rhs
        }
        
        var title: String
        
        init(title: String) {
            self.title = title
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tokenField: ResizingTokenField!
    @IBOutlet weak var animateSwitch: UISwitch!
    
    private lazy var titles: [String] = { "Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elit".components(separatedBy: " ") }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenField.layer.borderWidth = 1
        tokenField.layer.borderColor = UIColor.darkGray.cgColor
        tokenField.preferredReturnKeyType = .done
        tokenField.textFieldDelegate = self
        
        let placeholder = "Type here…"
        tokenField.placeholder = placeholder
        tokenField.textFieldMinWidth = placeholder.width(withFont: tokenField.font)
        
        tokenField.labelText = "Tokens:"
        let tokens: [Token] = [
            Token(title: "Lorem"),
            Token(title: "Ipsum")
        ]
        
        tokenField.append(tokens: tokens)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterFromKeyboardNotifications()
    }
    
    // MARK: - IB actions
    
    @IBAction func didTapAddTokenButton(_ sender: UIButton) {
        tokenField.append(tokens: [Token(title: getRandomTitle())], animated: animateSwitch.isOn, completion: nil)
    }
    
    @IBAction func didTapAddMultipleTokensButton(_ sender: UIButton) {
        var tokens: [Token] = []
        for _ in 0...(Int(arc4random_uniform(4)) + 1) {
            tokens.append(Token(title: getRandomTitle()))
        }

        tokenField.append(tokens: tokens, animated: animateSwitch.isOn)
    }
    
    @IBAction func didTapToggleLabelButton(_ sender: UIButton) {
        tokenField.isShowingLabel ? tokenField.hideLabel(animated: animateSwitch.isOn) : tokenField.showLabel(animated: animateSwitch.isOn)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == tokenField.textField else { return true }
        guard let text = textField.text, !text.isEmpty else { return true }
        
        tokenField.append(tokens: [Token(title: text)], animated: animateSwitch.isOn)
        tokenField.text = nil
        return false
    }
    
    // MARK: - Rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tokenField.handleOrientationChange()
    }
    
    // MARK: Keyboard
    
    override func keyboardVisibleHeightWillChange(newHeight: CGFloat) {
        scrollView.contentInset.bottom = newHeight
        scrollView.scrollIndicatorInsets.bottom = newHeight
    }
    
    // MARK: - Adding tokens
    
    private func getRandomTitle() -> String {
        return titles[Int(arc4random_uniform(UInt32(titles.count)))]
    }
    
}

