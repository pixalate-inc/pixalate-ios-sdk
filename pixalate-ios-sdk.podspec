Pod::Spec.new do |s|
  s.name             = 'pixalate-ios-sdk'
  s.version          = '0.1.1'
  s.summary          = 'An impression reporting library for ios apps, by Pixalate, Inc.'

  s.description      = <<-DESC
  Utility with which to send app impressions to Pixalate, as well as query about blocked status.
                       DESC

  s.homepage         = 'https://github.com/pixalate-inc/pixalate-ios-sdk'
  s.license          = { :type => 'LGPL-3.0', :file => 'LICENSE' }
  s.author           = { 'Pixalate, Inc.' => 'engineering-external@pixalate.com' }
  s.source           = { :git => 'https://github.com/pixalate-inc/pixalate-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'pixalate-ios-sdk/**/*'
  
  s.public_header_files = 'pixalate-ios-sdk/**/*.h'
end
