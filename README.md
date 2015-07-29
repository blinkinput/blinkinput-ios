<p align="center" >
  <img src="https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/logo-microblink.png" alt="MicroBlink" title="MicroBlink">
</p>

[![Build Status](https://travis-ci.org/BlinkOCR/blinkocr-ios.png)](https://travis-ci.org/BlinkOCR/blinkocr-ios.png)
[![Pod Version](http://img.shields.io/cocoapods/v/PPBlinkOCR.svg?style=flat)](http://cocoadocs.org/docsets/PPBlinkOCR/)


# BlinkOCR SDK for real time text recognition

BlinkOCR SDK is a state-of-the-art OCR module for mobile devices. It's OCR technology is optimized specifically for mobile devices and architectures. This allows faster results and lower error rate than regular desktop-based OCR software. BlinkOCR features: 

- integrated camera management
- integrated **text parsing** feature for fields like IBANs, prices, email addresses, urls, and many more!
- layered API, allowing everything from simple integration to complex UX customizations.
- lightweight and no internet connection required
- enteprise-level security standards

BlinkOCR is a part of family of SDKs developed by [MicroBlink](http://www.microblink.com) for optical text recognition, barcode scanning, ID document scanning and many others. 

BlinkOCR powers [PhotoMath app](https://photomath.net/en/) where it's used to [recognize mathematic expressions](https://vimeo.com/109405701) in real time. 

## How to get started

- [Download BlinkOCR SDK](https://github.com/BlinkOCR/blinkocr-ios/archive/master.zip) and try out the included iOS sample apps
- Read the ["Getting Started" guide](https://github.com/BlinkOCR/blinkocr-ios/wiki/Getting-started) to integrate the SDK in your app(s)
- [Generate](https://microblink.com/login?url=/customer/generatedemolicence) a **free demo license key** to start using the SDK in your app (registration required)
- [Contact us](http://www.microblink.com) to get pricing info
- Check out the [comprehensive documentation](http://cocoadocs.org/docsets/PPBlinkOCR/) of all APIs available in PDF417.mobi SDK
- If you're using CocoaPods, you can easily try our sample apps by running the following command in your terminal window:

```shell
pod try PPBlinkOCR
```

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like BlinkOCR in your projects. See the ["Getting Started" guide for more information](https://github.com/BlinkOCR/blinkocr-ios/wiki/Getting-started).

#### Podfile

```ruby
platform :ios, '6.0'
pod 'PPBlinkOCR', '~> 1.0.0'
```

## Requirements

SDK package contains MicroBlink framework and one or more sample apps which demonstrate framework integration. Framework can be deployed on iOS 6.0 or later, iPhone 3GS or newer and iPad 2 or newer. 

SDK performs significantly better when the images obtained from the camera are focused. Because of that, the SDK can have lower perfomance on iPad 2 and iPod Touch 4th gen devices, which [don't have camera with autofocus](http://www.adweek.com/socialtimes/ipad-2-rear-camera-has-tap-for-auto-exposure-not-auto-focus/12536).

## Important documents:

### ["Getting started" guide](https://github.com/BlinkOCR/blinkocr-ios/wiki/Getting-started)

See the steps for integrating the SDK in your apps. 

### [Release notes](https://github.com/BlinkOCR/blinkocr-ios/blob/master/Release%20notes.md)

See what's new in each new SDK version.

### [Transition guide](https://github.com/BlinkOCR/blinkocr-ios/blob/master/Transition%20guide.md)

See detailed description for transition from older version of the SDK.

## References

Partial list of companies using BlinkOCR SDK can be found [here](https://microblink.com/#references).

## Contact

1. Obtaining **free demo license key** (registration required):
[www.microblink.com/login](https://microblink.com/login?url=/customer/generatedemolicence)
2. Asking for technical help: [help.microblink.com](http://help.microblink.com)
3. [Contact us](http://www.microblink.com) to get pricing info

Copyright (c) 2015 MicroBlink Ltd. All rights reserved.