

Pod::Spec.new do |s|
  s.name             = "BCEventBus"
  s.version          = "0.1.0"
  s.summary          = "iOS BCEventBus"
  s.description      = <<-DESC.gsub(/^\s*\|?/,'')
                       An optional longer description of DiDiMap

                       | * Markdown format.
                       | * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/gfchenun/BCEventBus"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { :type => 'MIT' }
  s.author           = { "chasel" => "chasel.chen@qq.com" }
  s.source           = { :git => "https://github.com/gfchenun/BCEventBus.git", :branch => "develop" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.default_subspec = 'Core'

  #Event Bus模块
  s.subspec 'Core' do |core|
      core.public_header_files = 'Core/**/BCEventBusKit.h', 'Core/**/BCEventBus.h', 'Core/**/BCEventMarker.h'
      core.source_files = 'Core/**/*.{h,m}'
  end

  #app delegate模块
  s.subspec 'AppDelegate' do |appdelegate|
      appdelegate.public_header_files = 'AppDelegate/**/BCAppDelegate.h'
      appdelegate.source_files = 'AppDelegate/**/BCAppDelegate.*'
      appdelegate.dependency 'BCEventBus/Core'
      appdelegate.dependency 'BCFileLog'
  end
  
  #app delegate模块
  s.subspec 'ServiceLoader' do |serviceloader|
      serviceloader.public_header_files = 'ServiceLoader/**/BCServiceKit.h', 'ServiceLoader/**/BCServicePublic.h', 'ServiceLoader/**/BCServiceProtocol.h', 'ServiceLoader/**/BCServiceLoader.h'
      serviceloader.source_files = 'ServiceLoader/**/*.{h,m}'
  end
  

end
