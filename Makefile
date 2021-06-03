all:

build-project:
	xcodebuild clean

	xcodebuild build \
		-project Demobank\ Authenticator.xcodeproj \
		-scheme Demobank\ Authenticator \
		-destination 'generic/platform=iOS Simulator'