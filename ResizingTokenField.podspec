Pod::Spec.new do |s|
  s.name                  = 'ResizingTokenField'
  s.version               = '0.1.1'
  s.summary               = 'A token field implementation written in Swift 5.'
  s.homepage              = 'https://github.com/tadejr/ResizingTokenField.git'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Tadej Razborsek' => 'razborsek.tadej@gmail.com' }
  s.source                = { :git => 'https://github.com/tadejr/ResizingTokenField.git', :tag => s.version.to_s }
  s.swift_version         = '5.0'
  s.ios.deployment_target = '9.0'
  s.source_files          = 'ResizingTokenField/Classes/**/*'
  s.frameworks            = 'UIKit'
  s.description           = <<-DESC
  The token field displays an optional label at the start, a multiline list of tokens, and a text field at the end. Tokens can be collapsed into a text description. Internally it uses a collection view which supports insert and delete animations. Tokens can be customized by changing default token font and colors or providing entirely custom collection view cells. Token field provides an intrinsic content height which updates automatically as items are added and removed.
DESC
end
