[![Cocoapods](https://img.shields.io/cocoapods/v/OYStore.svg)](https://cocoapods.org/pods/OYStore)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-red.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/badge/platforms-iOS-yellow.svg)](https://github.com/osmanyildirim/OYStore)
[![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-14.2-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-lightgray.svg)](https://opensource.org/licenses/MIT)

<p align="left">
  <img src="Assets/Banner.png" title="OYStore">
</p>

Store persistent data or file in **UserDefaults**, **Keychain**, **File System**, **Memory Cache**.

> Supports persistence of all `Codable` types.

> *These types include Standard library types like String, Int; and Foundation types like Date, Data, URL etc.*
> <br>
> *That values can store as **.html**, **.json**, **.txt**, **.jpg**, **.png**, **.mov** and **.mp4** types in the file system.*

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
    - [UserDefaults](#userdefaults)
    - [Keychain](#keychain)
    - [Memory Cache](#memory-cache)
    - [Disk Cache](#disk-cache)
    - [Application Support](#application-support)
    - [Documents](#documents)
    - [Temporary](#temporary)
- [License](#license)

## Requirements

* iOS 11.0+
* Swift 5.0+

## Installation

<details>
<summary>CocoaPods</summary>
<br/>
<p>Add the following line to your <code>Podfile</code></p>

```
pod 'OYStore'
```
</details>

<details>
<summary>Swift Package Manager</summary>
<br/>
<p>Add OYStore as a dependency to your <code>Package.swift</code> and specify OYStore as a target dependency</p>

```swift
import PackageDescription
  
let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/osmanyildirim/OYStore", .upToNextMinor(from: "1.0")),
    ],
    targets: [
        .target(
            name: "YOUR_PROJECT_NAME",
            dependencies: ["OYStore"])
    ]
)
```
</details>

## Usage

### UserDefaults
- Save value
```swift
try OYStore.save(to: .userDefaults(key: "ud_string_value_key"), value: "ud_string_value")
```
```swift
try OYStore.save(to: .userDefaults(key: "ud_codable_value_key"), value: User())
```
```swift
try OYStore.save(to: .userDefaults(key: "ud_uiimage_value_key"), value: UIImage(named: "Sample")?.pngData())
```

- Fetch value
```swift
let value: User = try OYStore.value(of: .userDefaults(key: "ud_codable_value_key"))
```

- Fetch value with default
```swift
OYStore.value(of: .userDefaults(key: "ud_string_value_key"), default: "ud_default_value")
```

- Remove value
```swift
try OYStore.remove(of: .userDefaults(key: "ud_uiimage_value_key"))
```

- Remove all value
```swift
try OYStore.removeAll(of: .userDefaults)
```

### Keychain
- Save value
```swift
try OYStore.save(to: .keychain(key: "kc_string_value_key"), value: "kc_string_value")
```
```swift
try OYStore.save(to: .keychain(key: "kc_codable_value_key"), value: User())
```
```swift
try OYStore.save(to: .keychain(key: "kc_uiimage_value_key"), value: UIImage(named: "Sample")?.pngData())
```

- Fetch value
```swift
let value: User = try OYStore.value(of: .keychain(key: "kc_codable_value_key"))
```

- Fetch value with default
```swift
OYStore.value(of: .keychain(key: "kc_string_value_key"), default: "kc_default_value")
```

- Remove value
```swift
try OYStore.remove(of: .keychain(key: "kc_uiimage_value_key"))
```

- Remove all value
```swift
try OYStore.removeAll(of: .keychain)
```

### Memory Cache
> Backed by NSCache for store values on Memory.
> <br>

- Save value
```swift
try OYStore.save(to: .memoryCache(key: "mc_string_value_key"), value: "mc_string_value")
```
```swift
try OYStore.save(to: .memoryCache(key: "mc_codable_value_key"), value: User())
```
```swift
try OYStore.save(to: .memoryCache(key: "mc_uiimage_value_key"), value: UIImage(named: "Sample")?.pngData())
```

- Fetch value
```swift
let value: User = try OYStore.value(of: .memoryCache(key: "mc_codable_value_key"))
```

- Fetch value with default
```swift
OYStore.value(of: .memoryCache(key: "mc_string_value_key"), default: "mc_default_value")
```

- Remove value
```swift
try OYStore.remove(of: .memoryCache(key: "mc_uiimage_value_key"))
```

- Remove all value
```swift
try OYStore.removeAll(of: .memoryCache)
```

### Disk Cache
> <code>Library/Caches</code> Directory

> Note that the system may delete the <code>Caches</code> directory to free up disk space, so your app must be able to re-create or download these files as needed.

- Save value
```swift
try OYStore.save(to: .diskCache(file: "dc_text_file", type: .txt), value: "dc_text_value")
```
```swift
try OYStore.save(to: .diskCache(file: "dc_html_file", type: .html), value: "dc_html_value")
```
```swift
try OYStore.save(to: .diskCache(file: "dc_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```
... save value with Folder...
```swift
try OYStore.save(to: .diskCache(file: "dc_parent_folder/dc_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```

- Fetch value
```swift
let value: String = try OYStore.value(of: .diskCache(file: "dc_text_file", type: .txt))
```

- Fetch value with default
```swift
OYStore.value(of: .diskCache(file: "dc_text_file", type: .txt), default: "dc_default_value")
```

- Remove value
```swift
try OYStore.remove(of: .diskCache(key: "dc_uiimage_value_key"))
```

- Remove all value
```swift
try OYStore.removeAll(of: .diskCache)
```

### Application Support
> <code>Library/Application Support</code> Directory

> Store files in here that are required for your app but should never be visible to the user like your app’s database file. You can store files in here at the top level or create sub-directories. Content of the directory is persisted and included in the iCloud and iTunes backups.

- Save value
```swift
try OYStore.save(to: .applicationSupport(file: "as_text_file", type: .txt), value: "as_text_value")
```
```swift
try OYStore.save(to: .applicationSupport(file: "as_html_file", type: .html), value: "as_html_value")
```
```swift
try OYStore.save(to: .applicationSupport(file: "as_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```
... save value with Folder...
```swift
try OYStore.save(to: .applicationSupport(file: "as_parent_folder/as_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```

- Fetch value
```swift
let value: String = try OYStore.value(of: .applicationSupport(file: "as_text_file", type: .txt))
```

- Fetch value with default
```swift
OYStore.value(of: .applicationSupport(file: "as_text_file", type: .txt), default: "as_default_value")
```

- Remove value
```swift
try OYStore.remove(of: .applicationSupport(key: "as_uiimage_value_key"))
```

- Remove all value
```swift
try OYStore.removeAll(of: .applicationSupport)
```

### Documents
> <code>Documents</code> Directory

> Documents and other data that is user-generated and stored in the <code>Documents</code> directory can be automatically backed up by iCloud on iOS devices, if the iCloud Backup setting is turned on. The data can be recovered when user sets up a new device or resets an existing device.

- Save value
```swift
try OYStore.save(to: .documents(file: "d_text_file", type: .txt), value: "d_text_value")
```
```swift
try OYStore.save(to: .documents(file: "d_html_file", type: .html), value: "d_html_value")
```
```swift
try OYStore.save(to: .documents(file: "d_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```
... save value with Folder...
```swift
try OYStore.save(to: .documents(file: "d_parent_folder/d_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```

- Fetch value
```swift
let value: String = try OYStore.value(of: .documents(file: "d_text_file", type: .txt))
```

- Fetch value with default
```swift
OYStore.value(of: .documents(file: "d_text_file", type: .txt), default: "d_default_value")
```

- Remove value
```swift
try OYStore.remove(of: .documents(key: "d_uiimage_value_key"))
```

- Remove all value
```swift
try OYStore.removeAll(of: .documents)
```

### Temporary
> <code>tmp</code> Directory

> Data that is used only temporarily should be stored in the <code>tmp</code> directory. Although these files are not backed up to iCloud, remember to delete those files when you are done with them so that they do not continue to consume space on the user’s device.

- Save value
```swift
try OYStore.save(to: .temporary(file: "tmp_text_file", type: .txt), value: "tmp_text_value")
```
```swift
try OYStore.save(to: .temporary(file: "tmp_html_file", type: .html), value: "tmp_html_value")
```
```swift
try OYStore.save(to: .temporary(file: "tmp_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```
... save value with Folder...
```swift
try OYStore.save(to: .temporary(file: "d_parent_folder/tmp_image", type: .png), value: UIImage(named: "Sample")?.pngData())
```

- Fetch value
```swift
let value: String = try OYStore.value(of: .temporary(file: "tmp_text_file", type: .txt))
```

- Fetch value with default
```swift
OYStore.value(of: .temporary(file: "tmp_text_file", type: .txt), default: "tmp_default_value")
```

- Remove value
```swift
try OYStore.remove(of: .temporary(key: "tmp_uiimage_value_key"))
```

- Remove all value
```swift
try OYStore.removeAll(of: .temporary)
```

## License
OYStore is released under an MIT license. [See LICENSE](https://github.com/osmanyildirim/OYStore/blob/main/LICENSE) for details.