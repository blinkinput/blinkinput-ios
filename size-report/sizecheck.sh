#!/bin/sh

xcodebuild -project ../Samples/BlinkInput-sample-Swift/BlinkInput-sample-Swift.xcodeproj/ -sdk iphoneos archive -archivePath app.xcarchive -scheme BlinkInput-sample-Swift

xcodebuild -exportArchive -archivePath app.xcarchive -exportPath app.ipa -exportOptionsPlist exportOptions.plist -allowProvisioningUpdates

cp "app.ipa/App Thinning Size Report.txt" .
