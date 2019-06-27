//
//  CustomTokenCellViewController.swift
//  ResizingTokenField
//
//  Created by Tadej Razboršek on 25/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class CustomTokenCellViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ResizingTokenFieldDelegate, ResizingTokenFieldCustomCellDelegate {
    
    class Token: ResizingTokenFieldToken, Equatable {
        static func == (lhs: Token, rhs: Token) -> Bool {
            return lhs === rhs
        }
        
        var title: String
        var subtitle: String { return "A custom token" }
        
        init(title: String) {
            self.title = title
        }
    }
    
    private var names: [String] = []
    @IBOutlet weak var tokenField: ResizingTokenField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenField.labelText = "Tokens:"
        tokenField.showLabel()
        let placeholder = "Type to search…"
        tokenField.placeholder = placeholder
        tokenField.textFieldMinWidth = placeholder.width(withFont: tokenField.font)
        tokenField.delegate = self
        tokenField.customCellDelegate = self
        tokenField.textFieldDelegate = self
        tokenField.itemHeight = 40
        tokenField.preferredReturnKeyType = .done
        tokenField.makeTextFieldFirstResponderImmediately = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterFromKeyboardNotifications()
    }
    
    // MARK: - Rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tokenField.invalidateLayout()
    }
    
    // MARK: - ResizingTokenFieldDelegate
    
    func resizingTokenField(_ tokenField: ResizingTokenField, shouldRemoveToken token: ResizingTokenFieldToken) -> Bool {
        return true
    }
    
    func resizingTokenField(_ tokenField: ResizingTokenField, didEditText newText: String?) {
        defer { tableView.reloadData() }
        guard let text = newText, !text.isEmpty else {
            names.removeAll()
            return
        }
        names = randomNames.filter({ $0.hasPrefix(text) })
    }
    
    func resizingTokenFieldShouldCollapseTokens(_ tokenField: ResizingTokenField) -> Bool {
        return tokenField.tokens.count > 0
    }
    
    func resizingTokenFieldCollapsedTokensText(_ tokenField: ResizingTokenField) -> String? {
        return "Collapsed \(tokenField.tokens.count) token" + (tokenField.tokens.count == 1 ? "" : "s")
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        let isTokenAlreadyAdded: Bool = indexOfFirstToken(forName: names[indexPath.row]) != nil
        cell.accessoryType = isTokenAlreadyAdded ? .checkmark : .none
        
        return cell
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tokenField.textField {
            _ = tokenField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tokenIndex = indexOfFirstToken(forName: names[indexPath.row]) {
            tokenField.remove(tokensAtIndexes: [tokenIndex], animated: true)
        } else {
            tokenField.append(tokens: [Token(title: names[indexPath.row])], animated: true)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: - ResizingTokenFieldCustomCellDelegate
    
    func resizingTokenFieldCustomTokenCellClass(_ tokenField: ResizingTokenField) -> ResizingTokenFieldTokenCell.Type? {
        return nil
    }
    
    func resizingTokenFieldCustomTokenCellNib(_ tokenField: ResizingTokenField) -> UINib? {
        return UINib(nibName: "CustomTokenCell", bundle: nil)
    }
    
    func resizingTokenField(_ tokenField: ResizingTokenField, tokenCellWidthForToken token: ResizingTokenFieldToken) -> CGFloat {
        guard let token = token as? Token else { return 0 }
        let titleWidth = token.title.size(withAttributes: [.font: CustomTokenCell.titleFont]).width
        let subtitleWidth = token.subtitle.size(withAttributes: [.font: CustomTokenCell.subtitleFont]).width
        return 40 + 8 + ceil(max(titleWidth, subtitleWidth)) + 8  // Image placeholder + padding + max(title, subtitle) + padding
    }
    
    // MARK: Keyboard
    
    override func keyboardVisibleHeightWillChange(newHeight: CGFloat) {
        tableView.contentInset.bottom = newHeight
        tableView.scrollIndicatorInsets.bottom = newHeight
    }
    
    // MARK: - Finding tokens
    
    private func indexOfFirstToken(forName name: String?) -> Int? {
        return tokenField.tokens.firstIndex(where: { $0.title == name })
    }
    
    // MARK: - Names
    
    private let randomNames: [String] = ["Annabelle","Benjamin","Sean","Greta","Waylon","Ulysses","Valerie","Steve","Tom","Sheena","Thaddeus","Reed","Long","Christopher","Mabel","Ann","Evelyn","Margret","Rosemary","Augustine","Adan","Elsa","Lara","Gonzalo","Karl","Dylan","Lucien","Jeromy","Sophia","Fanny","Anna","Timothy","Ethan","Hans","Naomi","Maryellen","Debbie","Jamey","Daniel","Darlene","Frank","Kieth","Kelley","Tyrell","Lamont","Ambrose","Gilbert","Eugenio","Sanford","Emilio"]
}
