//
//  ResizingTokenField.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class ResizingTokenField: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Configuration
    
    /// If set, this will be the text style used for all labels.
    /// Otherwise default system font with fontSize will be used.
    var textStyle: UIFont.TextStyle? {
        get { return viewModel.textStyle }
        set { viewModel.textStyle = newValue }
    }
    
    /// Used if textStyle is not set. Default value 15.
    var fontSize: CGFloat {
        get { return viewModel.fontSize }
        set { viewModel.fontSize = newValue }
    }
    
    var tokens: [ResizingTokenFieldToken] {
        return viewModel.tokens
    }
    
    private var viewModel: ResizingTokenFieldViewModel = ResizingTokenFieldViewModel()
    
    private var collectionView: UICollectionView?
    
    /// Tracks when the initial collection view load is performed.
    /// This flag is used to prevent crashes from trying to insert/delete items before the initial load.
    private var isCollectionViewLoaded: Bool = false
    
    /// Height constraint of the collection view. This constraint's constant is updated as collection view resizes.
    private var heightConstraint: NSLayoutConstraint?
    
    var textField: UITextField? {
        return (collectionView?.cellForItem(at: viewModel.textFieldCellIndexPath) as? TextFieldCell)?.textField
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCollectionView()
        registerCells()
        
        viewModel.minimizeTextFieldCellSize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Duration.reloadDelay) { [weak self] in
            guard let self = self else { return }
            self.viewModel.invalidateTextFieldCellSize()
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func setUpCollectionView() {
        let layout = ResizingTokenFieldFlowLayout()
        layout.onContentHeightChanged = { [weak self] (oldHeight, newHeight) in
            self?.updateContentHeight(newHeight: newHeight, animated: false)
        }
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        
        addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        heightConstraint = NSLayoutConstraint(item: collectionView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: 100)
        heightConstraint!.priority = UILayoutPriority(rawValue: 999) // To avoid constraint issues when used in a UIStackView
        addConstraint(heightConstraint!)
        
        self.collectionView = collectionView
        viewModel.collectionView = collectionView
    }
    
    private func registerCells() {
        collectionView?.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.identifier)
        collectionView?.register(UINib(nibName: DefaultTokenCell.nibName, bundle: Bundle(for: DefaultTokenCell.self)),
                                forCellWithReuseIdentifier: DefaultTokenCell.identifier)
    }
    
    // MARK: - Rotation
    
    func handleOrientationChange() {
        viewModel.minimizeTextFieldCellSize()
        collectionView?.collectionViewLayout.invalidateLayout()
        
        // Invalidate layout after a short delay to strecth the text field cell.
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Duration.reloadDelay) { [weak self] in
            guard let self = self else { return }
            self.viewModel.invalidateTextFieldCellSize()
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: - Selecting tokens
    
    func selectLastToken() {
        if let indexPath = viewModel.lastTokenCellIndexPath, let cell = collectionView?.cellForItem(at: indexPath) as? ResizingTokenFieldTokenCell {
            _ = cell.becomeFirstResponder()
        }
    }
    
    // MARK: - Add/remove tokens
    
    func append(tokens: [ResizingTokenFieldToken], animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let newIndexPaths = viewModel.append(tokens: tokens)
        insertItemsThenResizeTextFieldCell(atIndexPaths: newIndexPaths, animated: animated, completion: completion)
    }
    
    /// Remove provided tokens, if they exist.
    func remove(tokens: [ResizingTokenFieldToken], replaceWithText text: String? = nil, animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let removedIndexPaths = viewModel.remove(tokens: tokens)
        removeItemsThenResizeTextFieldCell(atIndexPaths: removedIndexPaths, replaceWithText: text, animated: animated, completion: completion)
    }
    
    /// Remove tokens at provided indexes, if they exist.
    /// This function is the faster than `remove(tokens:)`.
    func remove(tokensAtIndexes indexes: IndexSet, replaceWithText text: String? = nil, animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let removedIndexPaths = viewModel.remove(tokensAtIndexes: indexes)
        removeItemsThenResizeTextFieldCell(atIndexPaths: removedIndexPaths, replaceWithText: text, animated: animated, completion: completion)
    }
    
    /// Convenience function for removing tokens at index paths.
    private func remove(tokensAtIndexPaths indexPaths: [IndexPath], replaceWithText text: String? = nil, animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let removedIndexPaths = viewModel.remove(tokensAtIndexPaths: indexPaths)
        removeItemsThenResizeTextFieldCell(atIndexPaths: removedIndexPaths, replaceWithText: text, animated: animated, completion: completion)
    }
    
    /// Inserts items and correctly resizes the text field cell.
    /// This is done by:
    /// - setting text field cell size to minimum
    /// - inserting new items; since text field cell width is set to minimum it will stay in the same row only if there is enough room
    /// - re-invalidates collectionView layout, causing the cell's size to be recalculated to correct width
    private func insertItemsThenResizeTextFieldCell(atIndexPaths indexPaths: [IndexPath], animated: Bool, completion: ((_ finished: Bool) -> Void)?) {
        guard isCollectionViewLoaded else {
            // Collection view initial load was not performed yet, items will be correctly configured there.
            completion?(true)
            return
        }
        
        viewModel.minimizeTextFieldCellSize()
        if animated {
            UIView.animate(withDuration: Constants.Duration.animationDefault, animations: {
                self.collectionView?.insertItems(at: indexPaths)
            }, completion: { (finished: Bool) in
                defer { completion?(finished) }
                guard finished else { return }
                self.viewModel.invalidateTextFieldCellSize()
                self.collectionView?.collectionViewLayout.invalidateLayout()
            })
        } else {
            UIView.performWithoutAnimation {
                collectionView?.insertItems(at: indexPaths)
            }
            
            // Invalidate layout after a short delay to strecth the text field cell.
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Duration.reloadDelay) { [weak self] in
                defer { completion?(true) }
                guard let self = self else { return }
                self.viewModel.invalidateTextFieldCellSize()
                self.collectionView?.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    /// Removes items and correctly resizes the text field cell.
    /// This is done by:
    /// - setting text field cell size to minimum
    /// - finding and removing items; since text field cell width is set to minimum it will stay in the same row only if there is enough room
    /// - re-invalidates collectionView layout, causing the cell's size to be recalculated to correct width
    private func removeItemsThenResizeTextFieldCell(atIndexPaths indexPaths: [IndexPath], replaceWithText text: String? = nil, animated: Bool, completion: ((_ finished: Bool) -> Void)?) {
        guard isCollectionViewLoaded else {
            // Collection view initial load was not performed yet, items will be correctly configured there.
            completion?(true)
            return
        }
        
        viewModel.minimizeTextFieldCellSize()
        if animated {
            UIView.animate(withDuration: Constants.Duration.animationDefault, animations: {
                self.collectionView?.deleteItems(at: indexPaths)
            }, completion: { (finished: Bool) in
                defer { completion?(finished) }
                guard finished else { return }
                self.viewModel.invalidateTextFieldCellSize()
                self.collectionView?.collectionViewLayout.invalidateLayout()
            })
        } else {
            UIView.performWithoutAnimation {
                collectionView?.deleteItems(at: indexPaths)
            }
            
            // Invalidate layout after a short delay to strecth the text field cell.
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Duration.reloadDelay) { [weak self] in
                defer { completion?(true) }
                guard let self = self else { return }
                self.viewModel.invalidateTextFieldCellSize()
                self.collectionView?.collectionViewLayout.invalidateLayout()
            }
        }
        
        _ = textField?.becomeFirstResponder()
        if let text = text {
            textField?.text = text
        }
    }
    
    // MARK: - Handling content height
    
    private func updateContentHeight(newHeight: CGFloat, animated: Bool) {
        heightConstraint?.constant = newHeight
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isCollectionViewLoaded = true
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.identifierForCell(atIndexPath: indexPath),
                                                      for: indexPath)
        switch cell {
        case let tokenCell as ResizingTokenFieldTokenCell:
            populate(tokenCell: tokenCell, atIndexPath: indexPath)
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
            tokenCell.onRemove = nil
            return
        }
        tokenCell.populate(withToken: token, font: viewModel.font)
        tokenCell.onRemove = { [weak self] (text) in
            self?.remove(tokens: [token], replaceWithText: text, animated: true, completion: nil)
        }
    }
    
    private func populate(textFieldCell: TextFieldCell, atIndexPath indexPath: IndexPath) {
        textFieldCell.onDeleteBackwardWhenEmpty = { [weak self] in
            self?.selectLastToken()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(indexPath: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ResizingTokenFieldTokenCell {
            _ = cell.becomeFirstResponder()
        }
    }

}
