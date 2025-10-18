Pod::Spec.new do |s|
  s.name             = 'flutter_shopscript'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for ShopScript e-commerce platform integration.'
  s.description      = <<-DESC
A comprehensive Flutter plugin for ShopScript e-commerce platform integration with authentication, cart management, product catalog, orders, and offline support.
                       DESC
  s.homepage         = 'https://github.com/nativemind/flutter_shopscript'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NativeMind' => 'support@nativemind.net' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

