#!/bin/bash

set -eo pipefail

cd LingoClash

xcodebuild clean test -project "LingoClash.xcodeproj" \
						-scheme "LingoClash" \
						-destination "platform=iOS Simulator,name=iPhone 12 Pro,OS=latest" \
						CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO ONLY_ACTIVE_ARCH=NO

cd ..