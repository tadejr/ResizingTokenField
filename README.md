# ResizingTokenField

[![Build Status](https://img.shields.io/travis/tadejr/ResizingTokenField.svg?style=flat)](https://travis-ci.org/tadejr/ResizingTokenField)
[![Version](https://img.shields.io/cocoapods/v/ResizingTokenField.svg?style=flat)](https://cocoapods.org/pods/ResizingTokenField)
[![License](https://img.shields.io/cocoapods/l/ResizingTokenField.svg?style=flat)](https://cocoapods.org/pods/ResizingTokenField)
[![Platform](https://img.shields.io/cocoapods/p/ResizingTokenField.svg?style=flat)](https://cocoapods.org/pods/ResizingTokenField)

A token field implementation written in Swift 5.

![Example GIF](https://media.giphy.com/media/kdiLStSleRNEA7QUR7/giphy.gif)

## Features

 - Can be used in Interface Builder or created programmatically
 - Uses a `UICollectionView` to display tokens, allowing token changes to be animated
 - Automatically updates intrinsic height as content is added and removed
 - Supports collapsing tokens into a text description
 - Allows providing a custom `UICollectionViewCell` for tokens

## Installation

### Cocoapods

ResizingTokenField is available through [CocoaPods](https://cocoapods.org). To install it, add the following to your `Podfile`:

```ruby
pod 'ResizingTokenField', '~> 0.1.1'
```

### Carthage

To install via [Carthage](https://github.com/Carthage/Carthage), add the following to your `Cartfile`:

```ogdl
github "tadejr/ResizingTokenField" "0.1.1"
```

## Usage

The token field can be used via Interface Builder - add an empty `UIView` to your layout and set its class to `ResizingTokenField`. It can also be initialized programmatically by using `init(frame:)`.

Meant to be used with auto layout; it provides intrinsic content height, meaning you only need to pin its position and width, height will change automatically as content is added and removed from the field. In Interface Builder, the Placeholder Intrinsic Size setting can be used for height.

### Configuration

Customization is possible by setting appropriate properties on a `ResizingTokenField` instance. Additionally, three different delegates can be set to handle specific behaviour. Check the example project for more info.

### Rotation support
The token field does not automatically invalidate layout when its bounds change. To handle device rotation you should manually invalidate layout.

```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    tokenField.invalidateLayout()   
}
```

### Height change animation
To animate changes to the token field's height you should call `layoutIfNeeded()` on an appropriate superview when token field intrinsic height changes.

```swift
func resizingTokenField(_ tokenField: ResizingTokenField, willChangeIntrinsicHeight newHeight: CGFloat) {
    view.layoutIfNeeded()
}

func resizingTokenField(_ tokenField: ResizingTokenField, didChangeIntrinsicHeight newHeight: CGFloat) {
    UIView.animate(withDuration: tokenField.animationDuration) {
        self.view.layoutIfNeeded()
    }
}
```

## Author

Tadej Razborsek, razborsek.tadej@gmail.com

## License

ResizingTokenField is available under the MIT license. See the LICENSE file for more info.
