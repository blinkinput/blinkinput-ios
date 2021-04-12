Pod::Spec.new do |s|
  
  s.name        = "PPBlinkOCR"
  s.version     = "5.0.0"
  s.summary     = "A state-of-the-art OCR module for mobile devices"
  s.homepage    = "http://microblink.com"
  
  s.description = <<-DESC
       BlinkOCR SDK is a state-of-the-art OCR module for mobile devices. It's OCR technology is optimized 
       specifically for mobile devices and architectures. This allows faster results and lower error rate 
       than regular desktop-based OCR software. BlinkOCR features: 

        - integrated camera management
        - integrated **text parsing** feature for fields like IBANs, prices, email addresses, urls, and many more!
        - layered API, allowing everything from simple integration to complex UX customizations.
        - lightweight and no internet connection required
        - enteprise-level security standards
        DESC
  
  s.license     = { 
        :type => 'commercial',
        :text => <<-LICENSE
                © 2013-2017 MicroBlink Ltd. All rights reserved.
                LICENSE
        }

  s.authors     = {
        "MicroBlink" => "info@microblink.com",
        "Jurica Cerovec" => "jurica.cerovec@microblink.com",
        "Jura Skrlec" => "jura.skrlec@microblink.com"
  }

  s.source      = { 
        :http => 'https://github.com/blinkinput/blinkinput-ios/releases/download/v5.0.0/blinkinput-ios_v5.0.0.tar.gz'
  }

  s.platform     = :ios

  # ――― MULTI-PLATFORM VALUES ――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = '9.0.0'
  s.ios.requires_arc = false
  s.ios.vendored_frameworks = 'BlinkInput.xcframework'
  s.ios.frameworks = 'Accelerate', 'AVFoundation', 'AudioToolbox', 'AssetsLibrary', 'CoreMedia'
  s.ios.libraries = 'c++', 'iconv', 'z'


end
