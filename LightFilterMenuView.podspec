#
# Be sure to run `pod lib lint LightFilterMenuView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LightFilterMenuView'
  s.version          = '0.5.0'
  s.summary          = '轻量筛选0.5.0'

  # swift version
  s.swift_version = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  轻量筛选轻量筛选轻量筛选轻量筛选轻量筛选轻量筛选轻量筛选轻量筛选轻量筛选轻量筛选
                       DESC

  s.homepage         = 'https://github.com/wangjie0223/LightFilterMenuView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangjie0223' => 'wangjie7629@163.com' }
  s.source           = { :git => 'https://github.com/wangjie0223/LightFilterMenuView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'LightFilterMenuView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LightFilterMenuView' => ['LightFilterMenuView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
