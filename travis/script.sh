#!/bin/sh
set -e

xcodebuild -project Samples/BlinkInput-sample/BlinkInput-sample.xcodeproj \
	-scheme BlinkInput-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/BlinkInput-sample/BlinkInput-sample.xcodeproj \
	-scheme BlinkInput-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

 xcodebuild -project Samples/Swift/BlinkOCR-sample-Swift/BlinkOCR-sample-Swift.xcodeproj \
	-scheme BlinkOCR-sample-Swift \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Swift/BlinkOCR-sample-Swift/BlinkOCR-sample-Swift.xcodeproj \
	-scheme BlinkOCR-sample-Swift \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

 xcodebuild -project Samples/Swift/DeepOCR-sample-Swift/DeepOCR-sample-Swift.xcodeproj \
	-scheme DeepOCR-sample-Swift \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Swift/DeepOCR-sample-Swift/DeepOCR-sample-Swift.xcodeproj \
	-scheme DeepOCR-sample-Swift \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build 	


 xcodebuild -project Samples/Swift/DirectAPI-sample-Swift/DirectAPI-sample-Swift.xcodeproj \
	-scheme DirectAPI-sample-Swift \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Swift/DirectAPI-sample-Swift/DirectAPI-sample-Swift.xcodeproj \
	-scheme DirectAPI-sample-Swift \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build  	

 xcodebuild -project Samples/Swift/FieldByField-sample-Swift/FieldByField-sample-Swift.xcodeproj \
	-scheme FieldByField-sample-Swift \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Swift/FieldByField-sample-Swift/FieldByField-sample-Swift.xcodeproj \
	-scheme FieldByField-sample-Swift \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build   	

 xcodebuild -project Samples/Swift/pdf417-sample-Swift/pdf417-sample-Swift.xcodeproj \
	-scheme pdf417-sample-Swift \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Swift/pdf417-sample-Swift/pdf417-sample-Swift.xcodeproj \
	-scheme pdf417-sample-Swift \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build    	

 xcodebuild -project Samples/Swift/Templating-sample-swift/Templating-sample-swift.xcodeproj \
	-scheme Templating-sample-swift \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/Swift/Templating-sample-swift/Templating-sample-swift.xcodeproj \
	-scheme Templating-sample-swift \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build  	