#
# Be sure to run `pod lib lint pxsdk-lib-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'pxsdk'
  s.version          = '0.1.0'
  s.summary          = 'An impression reporting library for ios apps, by Pixalate, Inc.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Utility with which to send app impressions to Pixalate, as well as query about blocked status.
                       DESC

  s.homepage         = 'https://github.com/Nate Tessman/pxsdk-lib-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'LGPL-3.0', :file => 'LICENSE' }
  s.author           = { 'Nate Tessman' => 'nate@pixalate.com' }
  s.source           = { :git => 'https://github.com/Nate Tessman/pxsdk-lib-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'pxsdk-lib-ios/Classes/**/*'
  
  # s.resource_bundles = {
  #   'pxsdk-lib-ios' => ['pxsdk-lib-ios/Assets/*.png']
  # }

  s.public_header_files = 'pxsdk-lib-ios/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
