#!/bin/sh
set -e

xcodebuild -project Samples/Templating-sample/Templating-sample.xcodeproj \
    -scheme Templating-Sample \
    -configuration Debug \
    -sdk iphonesimulator \
    ONLY_ACTIVE_ARCH=NO \
    clean build

xcodebuild -project Samples/Templating-sample/Templating-sample.xcodeproj \
    -scheme Templating-Sample \
    -configuration Release \
    -sdk iphonesimulator \
    ONLY_ACTIVE_ARCH=NO \
    clean build

xcodebuild -project Samples/BlinkOCR-sample/BlinkOCR-sample.xcodeproj \
	-scheme BlinkOCR-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/BlinkOCR-sample/BlinkOCR-sample.xcodeproj \
	-scheme BlinkOCR-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/DirectAPI-sample/DirectAPI-sample.xcodeproj \
	-scheme DirectAPI-Sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/DirectAPI-sample/DirectAPI-sample.xcodeproj \
	-scheme DirectAPI-Sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/SegmentScan-sample/SegmentScanDemo.xcodeproj \
	-scheme SegmentScanDemo \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/SegmentScan-sample/SegmentScanDemo.xcodeproj \
	-scheme SegmentScanDemo \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Receipt-sample/Receipt-sample.xcodeproj \
	-scheme Receipt-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Receipt-sample/Receipt-sample.xcodeproj \
	-scheme Receipt-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build