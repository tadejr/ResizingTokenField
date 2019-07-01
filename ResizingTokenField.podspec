#
# Be sure to run `pod lib lint ResizingTokenField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ResizingTokenField'
  s.version          = '0.1.0'
  s.summary          = 'A token field implementation written in Swift 5.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/tadejr/ResizingTokenField.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'razborsek.tadej@gmail.com' => 'razborsek.tadej@gmail.com' }
  s.source           = { :git => 'https://github.com/tadejr/ResizingTokenField.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'ResizingTokenField/Classes/**/*'
  s.frameworks = 'UIKit'
end
