//
//  ResizingTokenField.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

open class ResizingTokenField: UIView, UICollectionViewDataSource, UICollectionViewDelegate, ResizingTokenFieldFlowLayoutDelegate {
    
    // MARK: - Configuration
    
    /// Height of items.
    public var itemHeight: CGFloat {
        get { return viewModel.itemHeight }
        set {
            viewModel.customItemHeight = newValue
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    /// Insets of the internal collection view layout.
    public var contentInsets: UIEdgeInsets = Constants.Default.contentInsets {
        didSet {
            (collectionView.collectionViewLayout as? ResizingTokenFieldFlowLayout)?.sectionInset = contentInsets
        }
    }
    
    /// Spacing between items in a row.
    public var itemSpacing: CGFloat = Constants.Default.itemSpacing {
        didSet {
            (collectionView.collectionViewLayout as? ResizingTokenFieldFlowLayout)?.minimumInteritemSpacing = itemSpacing
        }
    }
    
    /// Spacing between rows.
    public var rowSpacing: CGFloat = Constants.Default.rowSpacing {
        didSet {
            (collectionView.collectionViewLayout as? ResizingTokenFieldFlowLayout)?.minimumLineSpacing = rowSpacing
        }
    }
    
    /// Font used by the token field.
    public var font: UIFont {
        get { return viewModel.font }
        set { viewModel.font = newValue }
    }
    
    // MARK: Label
    
    /// Boolean value, indicating if label is shown.
    public var isShowingLabel: Bool { return viewModel.isShowingLabelCell }
    
    /// Text to display in the label at the start.
    public var labelText: String? {
        get { return viewModel.labelCellText }
        set { viewModel.labelCellText = newValue }
    }
    
    /// Text color of the label at the start.
    public var labelTextColor: UIColor = Constants.Default.labelTextColor {
        didSet {
            if viewModel.isShowingLabelCell {
                collectionView.reloadItems(at: [viewModel.labelCellIndexPath])
            }
        }
    }
    
    // MARK: Tokens
    
    /// List of currently displayed tokens.
    public var tokens: [ResizingTokenFieldToken] { return viewModel.tokens }
    
    /// Indicates if tokens are currently collapsed or expanded.
    public var areTokensCollapsed: Bool { return viewModel.areTokensCollapsed }
    
    // MARK: Text field
    
    /// Reference to the current text field instance, or `nil` if no text field is loaded.
    /// The internal collection view cell for this text field is reloaded as few times as possible, but this reference can still change occasionally.
    public var textField: UITextField? { return (collectionView.cellForItem(at: viewModel.textFieldCellIndexPath) as? TextFieldCell)?.textField }
    
    /// Text color for the text field.
    public var textFieldTextColor: UIColor = Constants.Default.textFieldTextColor {
        didSet { textField?.textColor = textFieldTextColor }
    }
    
    /// Set to true to make text field first responder immediately after it loads.
    /// If `textField` returns a non-nil value it should be used instead of this flag.
    public var makeTextFieldFirstResponderImmediately: Bool = false
    
    /// Minimum allowed width of the text field. Will be stretched to the end of the last row.
    public var textFieldMinWidth: CGFloat {
        get { return viewModel.textFieldCellMinWidth }
        set { viewModel.textFieldCellMinWidth = newValue }
    }
    
    /// Text field return key type.
    public var preferredTextFieldReturnKeyType: UIReturnKeyType = .default {
        didSet { textField?.returnKeyType = preferredTextFieldReturnKeyType }
    }
    
    /// Text field `enablesReturnKeyAutomatically` flag.
    public var preferredTextFieldEnablesReturnKeyAutomatically: Bool = false {
        didSet { textField?.enablesReturnKeyAutomatically = preferredTextFieldEnablesReturnKeyAutomatically }
    }
    
    /// Placeholder shown by the text field.
    public var placeholder: String? {
        didSet { textField?.placeholder = placeholder }
    }
    
    /// Use to get/set currently displayed text.
    public var text: String? {
        get { return cachedText ?? textField?.text }
        set {
            if let textField = self.textField {
                textField.text = newValue
                textField.sendActions(for: .editingChanged)
            } else {
                cachedText = newValue
            }
        }
    }
    private var cachedText: String? // If text is set before text field cell is loaded.
    
    // MARK: Animation
    
    /// Duration of all animations performed by the token field.
    public var animationDuration: TimeInterval = Constants.Default.animationDuration
    
    /// Use to control animation when tokens are removed due to text input.
    /// For example, if user taps backspace while a token is selected.
    public var shouldTextInputRemoveTokensAnimated: Bool = true
    
    /// If `true` tokens will be collapsed using animation.
    public var shouldCollapseTokensAnimated: Bool = true
    
    /// If `true` tokens will be expanded using animation.
    public var shouldExpandTokensAnimated: Bool = true
    
    // MARK: Delegates
    
    public weak var delegate: ResizingTokenFieldDelegate?
    public weak var customCellDelegate: ResizingTokenFieldCustomCellDelegate? {
        didSet { registerCells() }
    }
    public weak var textFieldDelegate: UITextFieldDelegate? {
        didSet { textField?.delegate = textFieldDelegate }
    }
    
    // MARK: - Initialization
    
    let viewModel: ResizingTokenFieldViewModel = ResizingTokenFieldViewModel()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: ResizingTokenFieldFlowLayout())
    
    /// Tracks when the initial collection view load is performed.
    /// This flag is used to prevent crashes from trying to insert/delete items before the initial load.
    private var isCollectionViewLoaded: Bool = false
    
    /// Tracks when initial height is set. That height change does not notify the delegate.
    private var didSetInitialHeight: Bool = false
    
    /// The token field's intrinsic content height. Updated as collection view resizes.
    private var intrinsicContentHeight: CGFloat = 0 {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        setUpCollectionView()
        registerCells()
    }
    
    private func setUpCollectionView() {
        let layout = collectionView.collectionViewLayout as? ResizingTokenFieldFlowLayout
        layout?.sectionInset = contentInsets
        layout?.minimumInteritemSpacing = itemSpacing
        layout?.minimumLineSpacing = rowSpacing
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    private func registerCells() {
        collectionView.register(LabelCell.self, forCellWithReuseIdentifier: Constants.Identifier.labelCell)
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: Constants.Identifier.textFieldCell)
        
        if let customClass = customCellDelegate?.resizingTokenFieldCustomTokenCellClass(self) {
            collectionView.register(customClass, forCellWithReuseIdentifier: Constants.Identifier.tokenCell)
        } else if let customNib = customCellDelegate?.resizingTokenFieldCustomTokenCellNib(self) {
            collectionView.register(customNib, forCellWithReuseIdentifier: Constants.Identifier.tokenCell)
        } else {
            collectionView.register(DefaultTokenCell.self, forCellWithReuseIdentifier: Constants.Identifier.tokenCell)
        }
    }
    
    // MARK: - Content
    
    /// Use to invalidate the internal collection view layout.
    /// For example, use this to handle rotation change.
    public func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    /// Use to reload the internal collection view data.
    public func reloadData() {
        collectionView.reloadData()
    }
    
    // MARK: - First responder
    
    private var currentFirstResponderCell: UICollectionViewCell? {
        return collectionView.visibleCells.first(where: {
            $0.isFirstResponder || ($0 as? ResizingTokenFieldTokenCell)?.isBecomingFirstResponder == true
        })
    }
    
    open override var isFirstResponder: Bool {
        return currentFirstResponderCell != nil
    }
    
    open override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField?.becomeFirstResponder() == true
    }
    
    open override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        if let textField = self.textField, textField.isFirstResponder {
            return textField.resignFirstResponder()
        } else if let tokenCell = currentFirstResponderCell as? ResizingTokenFieldTokenCell {
            return tokenCell.resignFirstResponder()
        }
        
        return false
    }
    
    // MARK: - Toggle label
    
    public func showLabel(animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        toggleLabelCell(visible: true, animated: animated, completion: completion)
    }
    
    public func hideLabel(animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        toggleLabelCell(visible: false, animated: animated, completion: completion)
    }
    
    /// Shows/hides the label cell.
    private func toggleLabelCell(visible: Bool, animated: Bool, completion: ((_ finished: Bool) -> Void)?) {
        guard viewModel.isShowingLabelCell != visible else {
            completion?(true)
            return
        }
        
        viewModel.isShowingLabelCell = visible
        
        guard isCollectionViewLoaded else {
            // Collection view initial load was not performed yet, items will be correctly configured there.
            completion?(true)
            return
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                visible ? self.collectionView.insertItems(at: [self.viewModel.labelCellIndexPath]) : self.collectionView.deleteItems(at: [self.viewModel.labelCellIndexPath])
            }, completion: completion)
        } else {
            UIView.performWithoutAnimation {
                visible ? self.collectionView.insertItems(at: [self.viewModel.labelCellIndexPath]) : self.collectionView.deleteItems(at: [self.viewModel.labelCellIndexPath])
            }
        }
    }
    
    // MARK: - Add/remove tokens
    
    /// Append new tokens.
    ///
    /// - Parameters:
    ///   - tokens: Tokens to append.
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func append(tokens: [ResizingTokenFieldToken], animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let newIndexPaths = viewModel.append(tokens: tokens)
        insertItems(atIndexPaths: newIndexPaths, animated: animated, completion: completion)
    }
    
    /// Remove provided tokens, if they are in the token field.
    ///
    /// - Parameters:
    ///   - tokens: Tokens to remove.
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func remove(tokens: [ResizingTokenFieldToken], animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let removedIndexPaths = viewModel.remove(tokens: tokens)
        removeItems(atIndexPaths: removedIndexPaths, animated: animated, completion: completion)
    }
    
    /// Remove tokens at provided indexes, if they are in the token field.
    /// Faster than `remove(tokens:)`.
    ///
    /// - Parameters:
    ///   - indexes: Indexes of tokens to remove.
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func remove(tokensAtIndexes indexes: IndexSet, animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let removedIndexPaths = viewModel.remove(tokensAtIndexes: indexes)
        removeItems(atIndexPaths: removedIndexPaths, animated: animated, completion: completion)
    }
    
    /// Removes all tokens.
    ///
    /// - Parameters:
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func removeAllTokens(animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let removedIndexPaths = viewModel.removeAllTokens()
        removeItems(atIndexPaths: removedIndexPaths, animated: animated, completion: completion)
    }
    
    private func insertItems(atIndexPaths indexPaths: [IndexPath], animated: Bool, completion: ((_ finished: Bool) -> Void)?) {
        guard isCollectionViewLoaded, !indexPaths.isEmpty else {
            updateCollapsedTextIfNeeded()
            completion?(true)
            return
        }
        
        updateCollapsedTextIfNeeded()
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.collectionView.insertItems(at: indexPaths)
            }, completion: completion)
        } else {
            UIView.performWithoutAnimation {
                collectionView.insertItems(at: indexPaths)
            }
            completion?(true)
        }
    }
    
    private func removeItems(atIndexPaths indexPaths: [IndexPath], animated: Bool, completion: ((_ finished: Bool) -> Void)?) {
        guard isCollectionViewLoaded, !indexPaths.isEmpty else {
            updateCollapsedTextIfNeeded()
            completion?(true)
            return
        }
        
        updateCollapsedTextIfNeeded()
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.collectionView.deleteItems(at: indexPaths)
            }, completion: completion)
        } else {
            UIView.performWithoutAnimation {
                collectionView.deleteItems(at: indexPaths)
            }
            completion?(true)
        }
    }
    
    // MARK: - Collapse/expand tokens
    
    /// Collapses tokens and resigns first responder.
    ///
    /// - Parameters:
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func collapseTokens(animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        delegate?.resizingTokenField(self, willToggleTokensCollapsed: true)
        if let cell = currentFirstResponderCell {
            cell.resignFirstResponder()
        }
        textField?.text = delegate?.resizingTokenFieldCollapsedTokensText(self)
        
        let indexPaths = viewModel.toggle(areTokensCollapsed: true)
        removeItems(atIndexPaths: indexPaths, animated: animated, completion: { [weak self] (finished: Bool) in
            guard let self = self else { return }
            self.delegate?.resizingTokenField(self, didToggleTokensCollapsed: true)
        })
    }
    
    /// Expands tokens.
    ///
    /// - Parameters:
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func expandTokens(animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        delegate?.resizingTokenField(self, willToggleTokensCollapsed: false)
        textField?.text = nil
        
        let indexPaths = viewModel.toggle(areTokensCollapsed: false)
        insertItems(atIndexPaths: indexPaths, animated: animated, completion: { [weak self] (finished: Bool) in
            guard let self = self else { return }
            self.delegate?.resizingTokenField(self, didToggleTokensCollapsed: false)
        })
    }
    
    private func updateCollapsedTextIfNeeded() {
        guard viewModel.areTokensCollapsed else { return }
        textField?.text = delegate?.resizingTokenFieldCollapsedTokensText(self)
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isCollectionViewLoaded = true
        return viewModel.numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.identifierForCell(atIndexPath: indexPath),
                                                      for: indexPath)
        switch cell {
        case let tokenCell as ResizingTokenFieldTokenCell:
            populate(tokenCell: tokenCell, atIndexPath: indexPath)
        case let labelCell as LabelCell:
            populate(labelCell: labelCell, atIndexPath: indexPath)
        case let textFieldCell as TextFieldCell:
            populate(textFieldCell: textFieldCell, atIndexPath: indexPath)
        default:
            // Should never reach.
            break
        }
        
        return cell
    }
    
    private func populate(tokenCell: ResizingTokenFieldTokenCell, atIndexPath indexPath: IndexPath) {
        guard let token = viewModel.token(atIndexPath: indexPath) else {
            tokenCell.onShouldBeRemoved = nil
            tokenCell.onResignFirstResponder = nil
            return
        }
        
        if let defaultTokenCell = tokenCell as? DefaultTokenCell {
            defaultTokenCell.titleLabel.font = viewModel.font
            let configuration = delegate?.resizingTokenField(self, configurationForDefaultCellRepresenting: token)
            defaultTokenCell.configuration = configuration ?? Constants.Default.defaultTokenCellConfiguration
        }
        
        tokenCell.populate(withToken: token)
        tokenCell.onShouldBeRemoved = { [weak self] (replacementText: String?) in
            guard let self = self else { return }
            guard self.delegate?.resizingTokenField(self, shouldRemoveToken: token) != false else { return }
            self.remove(tokens: [token], animated: self.shouldTextInputRemoveTokensAnimated)
            _ = self.textField?.becomeFirstResponder()
            self.text = replacementText
        }
        tokenCell.onResignFirstResponder = { [weak self] (isBeingRemoved: Bool) in
            guard let self = self else { return }
            guard !isBeingRemoved else { return }
            guard self.delegate?.resizingTokenFieldShouldCollapseTokens(self) == true else { return }
            
            // Do not try to collapse if first responder moved to a token cell or the text field.
            let hasFirstResponder: Bool = self.currentFirstResponderCell != nil
            if !hasFirstResponder {
                self.collapseTokens(animated: self.shouldCollapseTokensAnimated, completion: nil)
            }
        }
    }
    
    private func populate(labelCell: LabelCell, atIndexPath indexPath: IndexPath) {
        labelCell.label.font = viewModel.font
        labelCell.label.textColor = labelTextColor
        labelCell.label.text = viewModel.labelCellText
    }
    
    private func populate(textFieldCell: TextFieldCell, atIndexPath indexPath: IndexPath) {
        if let text = cachedText {
            cachedText = nil
            textFieldCell.textField.text = text
        }
        
        textFieldCell.textField.placeholder = placeholder
        textFieldCell.textField.font = viewModel.font
        textFieldCell.textField.returnKeyType = preferredTextFieldReturnKeyType
        textFieldCell.textField.enablesReturnKeyAutomatically = preferredTextFieldEnablesReturnKeyAutomatically
        textFieldCell.textField.delegate = textFieldDelegate
        textFieldCell.textField.textColor = textFieldTextColor
        textFieldCell.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textFieldCell.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        textFieldCell.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        textFieldCell.onDeleteBackwardWhenEmpty = { [weak self] in self?.selectLastToken() }
        
        if makeTextFieldFirstResponderImmediately {
            makeTextFieldFirstResponderImmediately = false
            textFieldCell.textField.becomeFirstResponder()
        }
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        delegate?.resizingTokenField(self, didEditText: textField.text)
    }
    
    @objc private func textFieldEditingDidBegin(_ textField: UITextField) {
        expandTokens(animated: shouldExpandTokensAnimated, completion: nil)
    }
    
    @objc private func textFieldEditingDidEnd(_ textField: UITextField) {
        guard delegate?.resizingTokenFieldShouldCollapseTokens(self) == true else { return }
        
        // Do not try to collapse if first responder moved to a token cell.
        let hasFirstResponder: Bool = currentFirstResponderCell != nil
        if !hasFirstResponder {
            collapseTokens(animated: shouldCollapseTokensAnimated, completion: nil)
        }
    }
    
    private func selectLastToken() {
        if let indexPath = viewModel.lastTokenCellIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? ResizingTokenFieldTokenCell {
            _ = cell.becomeFirstResponder()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ResizingTokenFieldTokenCell {
            _ = cell.becomeFirstResponder()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let identifier = viewModel.identifierForCell(atIndexPath: indexPath)
        switch identifier {
        case Constants.Identifier.labelCell:
            return viewModel.labelCellSize
        case Constants.Identifier.textFieldCell:
            return viewModel.textFieldCellMinSize   // Will be stretched by layout if needed
        case Constants.Identifier.tokenCell:
            if let token = viewModel.token(atIndexPath: indexPath) {
                if let delegate = customCellDelegate {
                    return CGSize(width: delegate.resizingTokenField(self, tokenCellWidthForToken: token),
                                  height: itemHeight)
                }
                
                return viewModel.defaultTokenCellSize(forToken: token)
            }
        default:
            break
        }
        
        // Should never reach
        return .zero
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: intrinsicContentHeight)
    }
    
    // MARK: - ResizingTokenFieldFlowLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout: ResizingTokenFieldFlowLayout, heightDidChange newHeight: CGFloat) {
        guard didSetInitialHeight else {
            didSetInitialHeight = true
            intrinsicContentHeight = newHeight
            return
        }
        
        delegate?.resizingTokenField(self, willChangeIntrinsicHeight: newHeight)
        intrinsicContentHeight = newHeight
        delegate?.resizingTokenField(self, didChangeIntrinsicHeight: newHeight)
    }
    
    func lastCellIndexPath(in collectionView: UICollectionView, layout: ResizingTokenFieldFlowLayout) -> IndexPath {
        return viewModel.textFieldCellIndexPath
    }

}
