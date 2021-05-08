#
# Be sure to run `pod lib lint SDMSearchMapKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SDMSearchMapKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SDMSearchMapKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/CKTrue/SDMSearchMapKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CKTrue' => '1749437768@qq.com' }
  s.source           = { :git => 'https://github.com/CKTrue/SDMSearchMapKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SDMSearchMapKit/Classes/**/*.{h,m}'
  
   s.resource_bundles = {
     'SDMSearchMapKit' => ['SDMSearchMapKit/Assets/*.{png,storyboard,xib,xcassets}']
   }
  # s.public_header_files = 'Pod/Classes/Thirty/**/*.pch'
   s.prefix_header_contents = '#import "BaseViewController.h"','#import "BaseTableView.h"','#import "MacroDefinition.h"','#import "YCUIHeader.h"','#import "YCHeader.h"','#import "JumpVC.h"','#import "ToolManager.h"','#import "AFNetworking.h"','#import "Masonry.h"','#import "HttpManager.h"','#import "JQSafeKit.h"','#import "MJRefresh.h"','#import "MJExtension.h"','#import <WebKit/WebKit.h>','#import <AVKit/AVKit.h>','#import <AVFoundation/AVFoundation.h>','#import "SDPhotoBrowser.h"','#import "MBProgressHUD.h"','#import "UIView+WT.h"','#import <MapKit/MapKit.h>','#import "HSpeechRecognizer.h"','#import "SearchResultViewModel.h"','#import "CALayer+XibBorderColor.h"','#import "SearchResultModel.h"','#import "UIButton+TouchOne.h"','#import "CustomWebView.h"','#import "SVProgressHUD.h"','#import "SDMFindMyCar.h"'

   s.frameworks = 'UIKit', 'WebKit','AVKit','AVFoundation'
  # s.dependency 'AFNetworking', '~> 2.3'
 # s.dependency 'GoogleMaps','~> 4.0.0'
 # s.dependency 'GooglePlaces','~> 4.0.0'
  s.dependency 'AFNetworking'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'
  s.dependency 'SVProgressHUD'
end
