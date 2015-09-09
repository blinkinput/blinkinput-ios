#!/bin/sh
set -e

xctool -project Samples/BlinkOCR-sample/BlinkOCR-sample.xcodeproj \
	-scheme BlinkOCR-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xctool -project Samples/BlinkOCR-sample/BlinkOCR-sample.xcodeproj \
	-scheme BlinkOCR-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xctool -project Samples/NoCamera-sample/NoCamera-sample.xcodeproj \
	-scheme NoCamera-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xctool -project Samples/NoCamera-sample/NoCamera-sample.xcodeproj \
	-scheme NoCamera-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xctool -project Samples/FormScanning-sample/FormScanning-sample.xcodeproj \
	-scheme FormScanning-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xctool -project Samples/FormScanning-sample/FormScanning-sample.xcodeproj \
	-scheme FormScanning-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xctool -project Samples/pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xctool -project Samples/pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build