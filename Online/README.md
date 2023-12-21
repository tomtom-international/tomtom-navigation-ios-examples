# TomTom Navigation iOS SDK Examples

Hello and welcome to this repository with examples showcasing the [TomTom Navigation SDK for iOS].

> **Note** Navigation SDK for iOS is only available upon request. In order to get access, [contact us].

<div align="center">
  <img align="center" src=".github/nav-sdk-phone.png" width="400"/>
</div>

## Development setup

Before beginning, make sure you have Xcode 14 installed.

SPM or CocoaPods can be used to install the Navigation SDK. Both configurations are available in the examples. Please navigate to the related directory and find the project setup configuration.
- [Project setup for SPM]
- [Project setup for CocoaPods]

## API Keys

In order to manage, create or delete your API keys, you need to have a [TomTom Developer Portal] account.
If you don't have one, you need to [register] for one.
Follow the steps from [How to get a TomTom API Key] to learn how to create an API key.

> **Note** Using an invalid API key will cause issues loading the map or running navigation.

In order to insert your API key in the project, you need to change the `Keys.swift` file.

```swift
enum Keys {
    static let apiKey = "YOUR_API_KEY"
}
```

## Troubleshooting

If you have a **black screen** when launching the Basic driving app, please follow the steps below.

- Check that you have updated the `API key` with yours in the `Keys.swift` file.
- Check that your `API key` is valid for the requested features
- Check your internet connection

[contact us]: https://developer.tomtom.com/tomtom-sdk-for-ios/request-access
[How to get a TomTom API Key]: https://developer.tomtom.com/how-to-get-tomtom-api-key
[register]: https://developer.tomtom.com/user/register
[TomTom Navigation SDK for iOS]: https://developer.tomtom.com/ios/navigation/documentation/overview/introduction
[TomTom Developer Portal]: https://developer.tomtom.com/user/me/apps
[Project setup for SPM]: /SPM
[Project setup for CocoaPods]: /CocoaPods