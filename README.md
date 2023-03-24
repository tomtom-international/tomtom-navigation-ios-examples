# TomTom Navigation iOS SDK Examples
Hello and welcome to this repository with examples showcasing the [TomTom Navigation SDK for iOS](https://developer.tomtom.com/ios/navigation/documentation/overview/introduction)

Note: Navigation SDK for iOS is only available upon request. [Contact us](https://developer.tomtom.com/tomtom-sdk-for-ios/request-access) to get access.

<div align="center">
  <img align="center" src=".github/nav-sdk-phone.png" width="400"/>
</div>

## Setup
Once you have obtained access, do the following:

## Cloning the repository
Clone the repository https://github.com/tomtom-international/tomtom-navigation-ios-examples

## iOS setup

1. Install [Xcode](https://apps.apple.com/app/id497799835) 14 or higher if you don't already have it.
2. Install [Cocoapods](https://guides.cocoapods.org/using/getting-started.html) on your computer.
    ```
    sudo gem install cocoapods
    ```
3. Install cocoapods-art plugin on your computer.
    ```
    sudo gem install cocoapods-art
    ```
4. Because the repository for Navigation SDK is private, you will need to [contact us](https://developer.tomtom.com/tomtom-sdk-for-ios/request-access) to get access. Once you have obtained access, 
- Go to [repositories.tomtom.com](https://repositories.tomtom.com/ui) and log in with your account. 
- Expand the user menu in the top-right corner, and select "Edit profile" → "Generate an Identity Token". 
- Copy your token and put it, together with your login, in ~/.netrc. If the file doesn’t exist, create one and add the following entry:
    ```
    machine repositories.tomtom.com
    login <YOUR_EMAIL_ADDRESS>
    password <YOUR_TOKEN>
    ```
5. Add a reference to the cocoapods-art repository:
    ```
    pod repo-art add tomtom-sdk-cocoapods "https://repositories.tomtom.com/artifactory/api/pods/cocoapods"
    ```
6. Install the dependencies by executing the following command in **the project folder**.
    ```
    pod install
    ```
7. To update the SDK version, run the command:
    ```
    pod repo-art update tomtom-sdk-cocoapods
    ```
8. Open the project’s `xcworkspace`.

## API Keys

Make sure you have the appropriate TomTom API key. If you don’t have an API Key, go to [How to get a TomTom API Key](https://developer.tomtom.com/how-to-get-tomtom-api-key) to learn how to create one. Using an invalid API key will cause issues loading the map or running navigation.

Change your API key in the `Keys.swift` file. 

```
enum Keys {
    static let apiKey = "YOUR_API_KEY"
}
```

## Troubleshooting
If you have a **black screen** when launching the Basic driving app, please follow the steps below.

- Check that you have updated the `API key` with yours in the `Keys.swift` file.
- Check that your `API key` is valid for the requested features
- Check your internet connection

---

If you get a warning about the device's architecture, please follow the steps below.
```
Warning: Error creating LLDB target at path '*' using an empty LLDB target which can cause slow memory reads from remote devices: the specified architecture 'arm64-*-*' is not compatible with 'x86_64-apple-ios*' 
```

### Apple M1 and M2 processor support

Xcode requires a specific setup to support TomTom SDK on Apple M1 and M2 processors devices. The existing frameworks are optimized for Intel processors. Apple introduced Rosetta to emulate devices with Apple M1 and M2 processors, using Intel processors for backward compatibility. Please follow the steps below to run Rosetta during the build process:

1. Skip this section if your device uses an Intel processor:
- go to `Apple Menu` -> `About This Mac` to check
2. Automatically open Xcode using Rosetta:
- go to `Applications` -> `Xcode` -> `Right mouse click` (control + click) -> `Get Info`
- check the flag `Open using Rosetta`

---