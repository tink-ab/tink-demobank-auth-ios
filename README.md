# Tink Demo Bank Authenticator iOS
[Tink Demo Bank](https://docs.tink.com/resources/aggregation/test-providers) is a new way of testing with dynamic test cases in Tink. Tink Demo Bank can be used to test common and custom use cases with realistic account data, balances and transactions, without having to enter real bank credentials.

In order to properly test an app-to-app redirection flow you also need this companion app that works as an authenticator towards the Tink Demo Bank. This allows you to simulate and verify that this type of provider works well with your implementation. 

The exact `providerName` of providers that simulate this flow are in the format `xx-demobank-open-banking-app-to-app` where `xx` is the market code (eg `uk`). 

## Requirements 
- [Xcode 12](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
- A Mac 

## Installation

Open `Demobank Authenticator.xcodeproj`. If you only want to build the app for a simulator, you can simply choose the device model you want in the dropdown list and press _Run_. 

If you would like to build to your device you need to connect it to your Mac and choose it in the dropdown list. In order to run on a real device you will need to log in to your Apple ID in Preferences and select a Team on the Signing & Capabilities pane of the project editor. The easiest way to get started is to also let Xcode handle signing by enabling _Automatically manage signing_ and selecting your _Personal Team_ as the team for the project. 

For a more thorough explanation on how to set up Xcode, refer to [Apples documentation](https://developer.apple.com/documentation/xcode/running_your_app_in_the_simulator_or_on_a_device). 