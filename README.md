[![Cocoapods](https://img.shields.io/cocoapods/v/OYStore.svg)](https://cocoapods.org/pods/OYStore)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-red.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/badge/platforms-iOS-yellow.svg)](https://github.com/osmanyildirim/OYStore)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-16.0-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-lightgray.svg)](https://opensource.org/licenses/MIT)

<p align="left">
  <img src="Assets/Banner.png" title="OYStore">
</p>

Store persistent data or file in **UserDefaults**, **Keychain**, **File System**, **Memory Cache**.

> Supports persistence of all `Codable` types.

> *These types include Standard library types like String, Int; and Foundation types like Date, Data, URL etc.*
> <br>
> *That datas can store as **.html**, **.json**, **.txt**, **.jpg**, **.png**, **.mov** and **.mp4** types in the file system.*

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
    - [UserDefaults](#userdefaults)
    - [Keychain](#keychain)
    - [Memory Cache](#memory-cache)
    - [URL Cache](#url-cache)
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
- Save data
```swift
try OYStore.save(to: .userDefaults(key: "ud_string_data_key"), data: "ud_string_data")
```
```swift
try OYStore.save(to: .userDefaults(key: "ud_codable_data_key"), data: User())
```
```swift
try OYStore.save(to: .userDefaults(key: "ud_uiimage_data_key"), data: UIImage(named: "Sample")?.pngData())
```

- Fetch data
```swift
let data: User = try OYStore.data(of: .userDefaults(key: "ud_codable_data_key"))
```

- Fetch data with default
```swift
OYStore.data(of: .userDefaults(key: "ud_string_data_key"), default: "ud_default_data")
```

- Remove data
```swift
try OYStore.remove(of: .userDefaults(key: "ud_uiimage_data_key"))
```

- Remove all data
```swift
try OYStore.removeAll(of: .userDefaults)
```

- Is data exist?
```swift
try OYStore.isExist(at: .userDefaults(key: "ud_codable_data_key"))
```

- Move data
`--UserDefaults doesn't support data move`

### Keychain
- Save data
```swift
try OYStore.save(to: .keychain(key: "kc_string_data_key"), data: "kc_string_data")
```
```swift
try OYStore.save(to: .keychain(key: "kc_codable_data_key"), data: User())
```
```swift
try OYStore.save(to: .keychain(key: "kc_uiimage_data_key"), data: UIImage(named: "Sample")?.pngData())
```

- Fetch data
```swift
let data: User = try OYStore.data(of: .keychain(key: "kc_codable_data_key"))
```

- Fetch data with default
```swift
OYStore.data(of: .keychain(key: "kc_string_data_key"), default: "kc_default_data")
```

- Remove data
```swift
try OYStore.remove(of: .keychain(key: "kc_uiimage_data_key"))
```

- Remove all data
```swift
try OYStore.removeAll(of: .keychain)
```

- Is data exist?
```swift
try OYStore.isExist(at: .keychain(key: "kc_codable_data_key"))
```

- Move data
`--Keychain doesn't support data move`

### Memory Cache
> Backed by NSCache for store datas on Memory.
> <br>

- Save data
```swift
try OYStore.save(to: .memoryCache(key: "mc_string_data_key"), data: "mc_string_data")
```
```swift
try OYStore.save(to: .memoryCache(key: "mc_codable_data_key"), data: User())
```
```swift
try OYStore.save(to: .memoryCache(key: "mc_uiimage_data_key"), data: UIImage(named: "Sample")?.pngData())
```

- Fetch data
```swift
let data: User = try OYStore.data(of: .memoryCache(key: "mc_codable_data_key"))
```

- Fetch data with default
```swift
OYStore.data(of: .memoryCache(key: "mc_string_data_key"), default: "mc_default_data")
```

- Remove data
```swift
try OYStore.remove(of: .memoryCache(key: "mc_uiimage_data_key"))
```

- Remove all data
```swift
try OYStore.removeAll(of: .memoryCache)
```

- Is data exist?
```swift
try OYStore.isExist(at: .memoryCache(key: "mc_codable_data_key"))
```

- Move data
`--Memory Cache doesn't support data move`

### URL Cache
> Cache for <code>URLRequest</code>

- Cache response
```swift
let session = URLSession.shared
let request = URLRequest(url: URL(string: "API_URL")!)

session.dataTask(with: request) { data, response, error in
    try? OYStore.save(to: .urlCache(urlRequest: request, data: data, urlSession: session, urlResponse: response))
}.resume()
```
- Fetch cached response
```swift
let request = URLRequest(url: URL(string: "API_URL")!)
let data: User = try OYStore.data(of: .urlCache(urlRequest: request))
```

- Remove cached response
```swift
let request = URLRequest(url: URL(string: "API_URL")!)
OYStore.remove(of: .urlCache(urlRequest: request))
```

- Remove all cached responses
```swift
try? OYStore.removeAll(of: .urlCache)
```

- Is data exist?
```swift
try OYStore.isExist(at: .urlCache(key: "mc_codable_data_key"))
```

- Move data
`--URL Cache doesn't support data move`

### Disk Cache
> <code>Library/Caches</code> Directory

> Note that the system may delete the <code>Caches</code> directory to free up disk space, so your app must be able to re-create or download these files as needed.

- Save data
```swift
try OYStore.save(to: .diskCache(file: "dc_text_file", type: .txt), data: "dc_text_data")
```
```swift
try OYStore.save(to: .diskCache(file: "dc_html_file", type: .html), data: "dc_html_data")
```
```swift
try OYStore.save(to: .diskCache(file: "dc_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```
... save data with Folder...
```swift
try OYStore.save(to: .diskCache(file: "dc_parent_folder/dc_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```

- Fetch data
```swift
let data: String = try OYStore.data(of: .diskCache(file: "dc_text_file", type: .txt))
```

- Fetch data with default
```swift
OYStore.data(of: .diskCache(file: "dc_text_file", type: .txt), default: "dc_default_data")
```

- Remove data
```swift
try OYStore.remove(of: .diskCache(key: "dc_uiimage_data_key"))
```

- Remove all data
```swift
try OYStore.removeAll(of: .diskCache)
```

- Is data exist?
```swift
try OYStore.isExist(at: .diskCache(key: "mc_codable_data_key"))
```

- Move data
```swift
try OYStore.move(from: .diskCache(file: "ds_text_file", type: .txt), to: .documents(file: "d_parent_folder/as_text_file", type: .txt))
```

### Application Support
> <code>Library/Application Support</code> Directory

> Store files in here that are required for your app but should never be visible to the user like your app’s database file. You can store files in here at the top level or create sub-directories. Content of the directory is persisted and included in the iCloud and iTunes backups.

- Save data
```swift
try OYStore.save(to: .applicationSupport(file: "as_text_file", type: .txt), data: "as_text_data")
```
```swift
try OYStore.save(to: .applicationSupport(file: "as_html_file", type: .html), data: "as_html_data")
```
```swift
try OYStore.save(to: .applicationSupport(file: "as_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```
... save data with Folder...
```swift
try OYStore.save(to: .applicationSupport(file: "as_parent_folder/as_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```

- Fetch data
```swift
let data: String = try OYStore.data(of: .applicationSupport(file: "as_text_file", type: .txt))
```

- Fetch data with default
```swift
OYStore.data(of: .applicationSupport(file: "as_text_file", type: .txt), default: "as_default_data")
```

- Remove data
```swift
try OYStore.remove(of: .applicationSupport(key: "as_uiimage_data_key"))
```

- Remove all data
```swift
try OYStore.removeAll(of: .applicationSupport)
```

- Is data exist?
```swift
try OYStore.isExist(at: .applicationSupport(file: "as_text_file", type: .txt))
```

- Move data
```swift
try OYStore.move(from: .applicationSupport(file: "as_text_file", type: .txt), to: .documents(file: "d_parent_folder/d_text_file", type: .txt))
```

### Documents
> <code>Documents</code> Directory

> Documents and other data that is user-generated and stored in the <code>Documents</code> directory can be automatically backed up by iCloud on iOS devices, if the iCloud Backup setting is turned on. The data can be recovered when user sets up a new device or resets an existing device.

- Save data
```swift
try OYStore.save(to: .documents(file: "d_text_file", type: .txt), data: "d_text_data")
```
```swift
try OYStore.save(to: .documents(file: "d_html_file", type: .html), data: "d_html_data")
```
```swift
try OYStore.save(to: .documents(file: "d_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```
... save data with Folder...
```swift
try OYStore.save(to: .documents(file: "d_parent_folder/d_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```

- Fetch data
```swift
let data: String = try OYStore.data(of: .documents(file: "d_text_file", type: .txt))
```

- Fetch data with default
```swift
OYStore.data(of: .documents(file: "d_text_file", type: .txt), default: "d_default_data")
```

- Remove data
```swift
try OYStore.remove(of: .documents(key: "d_uiimage_data_key"))
```

- Remove all data
```swift
try OYStore.removeAll(of: .documents)
```

- Is data exist?
```swift
try OYStore.isExist(at: .documents(file: "d_text_file", type: .txt))
```

- Move data
```swift
try OYStore.move(from: .documents(file: "d_text_file", type: .txt), to: .applicationSupport(file: "as_parent_folder/as_text_file", type: .txt))
```

### Temporary
> <code>tmp</code> Directory

> Data that is used only temporarily should be stored in the <code>tmp</code> directory. Although these files are not backed up to iCloud, remember to delete those files when you are done with them so that they do not continue to consume space on the user’s device.

- Save data
```swift
try OYStore.save(to: .temporary(file: "tmp_text_file", type: .txt), data: "tmp_text_data")
```
```swift
try OYStore.save(to: .temporary(file: "tmp_html_file", type: .html), data: "tmp_html_data")
```
```swift
try OYStore.save(to: .temporary(file: "tmp_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```
... save data with Folder...
```swift
try OYStore.save(to: .temporary(file: "tmp_parent_folder/tmp_image", type: .png), data: UIImage(named: "Sample")?.pngData())
```

- Fetch data
```swift
let data: String = try OYStore.data(of: .temporary(file: "tmp_text_file", type: .txt))
```

- Fetch data with default
```swift
OYStore.data(of: .temporary(file: "tmp_text_file", type: .txt), default: "tmp_default_data")
```

- Remove data
```swift
try OYStore.remove(of: .temporary(key: "tmp_uiimage_data_key"))
```

- Remove all data
```swift
try OYStore.removeAll(of: .temporary)
```

- Is data exist?
```swift
try OYStore.isExist(at: .temporary(file: "tmp_text_file", type: .txt))
```

- Move data
```swift
try OYStore.move(from: .temporary(file: "tmp_text_file", type: .txt), to: .applicationSupport(file: "as_parent_folder/as_text_file", type: .txt))
```

## License
OYStore is released under an MIT license. [See LICENSE](https://github.com/osmanyildirim/OYStore/blob/main/LICENSE) for details.