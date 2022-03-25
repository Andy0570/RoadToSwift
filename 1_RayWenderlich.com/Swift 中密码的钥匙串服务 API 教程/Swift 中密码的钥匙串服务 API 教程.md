> 原文：[Keychain Services API Tutorial for Passwords in Swift](https://www.raywenderlich.com/9240-keychain-services-api-tutorial-for-passwords-in-swift)
>
> 在这个 iOS 上的 Swift 钥匙串教程中，您将学习如何与 C 语言 API 交互以将密码安全地存储在 iOS 钥匙串中。



对于 Apple 开发人员而言，最重要的安全要素之一是 iOS 钥匙串（**iOS Keychain**），这是一个用于存储元数据和敏感信息的专用数据库。使用钥匙串是存储对您的应用程序至关重要的小块数据（如密钥和密码）的最佳方式。

直接与 Keychain 交互很复杂，尤其是在 Swift 中。您必须使用主要是由 C 语言编写的 **Security** 框架。

有不同的 Swift 包装器允许您与 Keychain 进行交互。 Apple 甚至提供了一款名为 [GenericKeychain](https://developer.apple.com/library/archive/samplecode/GenericKeychain/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007797-Intro-DontLinkElementID_2) 的产品，让您的生活更轻松。

尽管您可以轻松地使用第三方包装器与 Apple 提供的不友好 API 进行交互，但了解 Keychain Services 会为您的开发人员工具带添加一个有价值的工具。

在本教程中，您将深入研究 **Keychain Services API**，并学习如何创建自己的包装器，并将其开发为 iOS 框架。

特别是，您将学习如何添加、修改、删除和搜索通用密码和互联网密码。此外，您将提供单元测试来验证您的代码是否按预期工作。

## 开始

在本教程中，您将使用 SecureStore，这是一个样板 iOS 框架，您将在其中实现您的钥匙串服务 API。

首先使用本教程顶部或底部的“下载材料”按钮下载启动项目。下载后，在 Xcode 中打开 SecureStore.xcodeproj。

为了让您保持专注，启动项目已经为您设置了与实现包装器相关的所有内容。

您的项目结构应如下所示：

![Project Structure](https://koenig-media.raywenderlich.com/uploads/2018/11/keychain_project_structure-1.png)

包装器的代码位于 SecureStore 组文件夹中：

* **SecureStoreError.swift**：包含一个枚举类型，它代表你的包装器可以处理的所有可能的错误。与 `LocalizedError` 一致，`SecureStoreError` 提供了描述错误及其发生原因的本地化消息。
* **SecureStoreQueryable.swift**：定义一个与文件同名的协议。 `SecureStoreQueryable` 强制要求实现者提供定义为类型为 `[String: Any]` 的字典的 `query` 属性。在内部，您的 API 仅处理这些类型的对象。稍后再谈。
* **SecureStore.swift**：定义您将在本教程中实现的包装器。它提供了一个初始化程序和一堆用于从钥匙串中添加、更新、删除和检索密码的存根方法。消费者可以通过注入一些遵守 `SecureStoreQueryable` 的类型来创建包装器的实例。
* **InternetProtocol.swift**：表示您可以处理的所有可能的 Internet 协议值。
* **InternetAuthenticationType.swift**：描述您的包装器提供的身份验证机制。

> 注意：依赖注入（*Dependency injection*）允许您编写扩展和隔离功能的类。对于一个非常简单的概念来说，这是一个有点可怕的词。您将在本教程中看到“注入”一词，它指的是将整个对象传递给初始化程序。

除了框架代码，您还应该有另外两个文件夹：SecureStoreTests 和 TestHost。前者包含您将随框架一起提供的单元测试。后者包含一个空应用程序，您将使用它来测试您的框架 API。

> 注意：通常，要测试您在教程中编写的代码，您需要在模拟器中运行应用程序。而不是这样做，您将通过运行单元测试来验证您的代码是否正常工作。所以项目中的测试宿主应用程序不会在模拟器中运行；相反，它充当为您的框架执行单元测试的容器。

在直接深入代码之前，先看看一些理论！



## 钥匙串服务概述

为什么要使用钥匙串（*Keychain*）而不是更简单的解决方案？将用户的 base-64 编码后的密码存储在 `UserDefaults` 中还不够吗？

当然不！攻击者很容易恢复以这种方式存储的密码。

钥匙串服务可帮助您代表用户将条目或小块数据安全地存储到加密数据库中。

在 Apple 的文档中，`SecKeychain` 类代表一个数据库，而 `SecKeychainItem` 类代表一个条目。

钥匙串服务的运作方式因您运行的操作系统而异。

在 iOS 中，应用程序可以访问包含 iCloud 钥匙串的单个钥匙串。锁定和解锁设备会自动锁定和解锁钥匙串。这可以防止不必要的访问。此外，应用程序只能访问其自己的 items 或与它所属的组共享的 items。

另一方面，macOS 支持多个钥匙串。您通常依靠用户使用 Keychain Access （钥匙串访问）应用程序来管理这些，并隐式使用默认的钥匙串。此外，您可以直接操作钥匙串；例如，创建和管理对您的应用严格保密的钥匙串。

当您想要存储密码等密钥时，您可以将其打包为 keychain item。这是一种不透明类型，由两部分组成：数据和一组属性。就在它插入一个新 item 之前，Keychain Services 对数据进行加密，然后将其与其属性包装在一起。

![Keychain Services](https://koenig-media.raywenderlich.com/uploads/2018/11/keychain_services_encryption-1-650x256.png)



使用属性（attributes）来识别和存储元数据或控制对存储项目的访问。将属性指定并表示为 `CFDictionary` 类型字典的键值对。您可以在 [Item Attribute Keys and Values](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values) 中找到可用键的列表。对应的值可以是字符串、数字、其他一些基本类型，或者是随 **Security** 框架打包的常量。

钥匙串服务提供特殊类型的属性，允许您识别特定项目的类别。在本教程中，您将同时使用 `kSecClassGenericPassword` 和 `kSecClassInternetPassword` 来处理通用密码和互联网密码。

每个类只支持一组特殊的属性。换言之，并非所有属性都适用于特定的项目类别。您可以在相关的项目类别价值文档中验证它们。

> 注意：除了操纵密码，Apple 还提供了与其他类型的项目（如证书、加密密钥和身份）进行交互的机会。它们分别由 `kSecClassCertificate`、`kSecClassKey` 和 `kSecClassIdentity` 类表示。



## 深入了解钥匙串服务 API

由于代码对恶意用户隐藏了 items，因此 **Keychain Services** 提供了一组 C 函数进行交互。以下是您将用于操作通用密码和互联网密码的 API：

* `SecItemAdd(_:_:)`：使用此函数将一个或多个 items 添加到钥匙串中。
* `SecItemCopyMatching(_:_:)`：此函数返回一个或多个与搜索查询匹配的钥匙串项。此外，它可以复制特定钥匙串项的属性。
* `SecItemUpdate(_:_:)`：此函数允许您修改匹配搜索查询的钥匙串项。
* `SecItemDelete(_:)`：此函数删除与搜索查询匹配的钥匙串项。


虽然上述函数使用不同的参数进行操作，但它们都返回一个表示为 `OSStatus` 的结果代码。这是一个 32 位有符号整数，它可以采用 [Item Return Result Keys](https://developer.apple.com/documentation/security/1542001-security_framework_result_codes) 中列出的值之一。

由于 `OSStatus` 可能难以理解，Apple 提供了一个名为 `SecCopyErrorMessageString(_:_:)` 的附加 API，以获取与这些状态代码相对应的人类可读的字符串。

> 注意：除了添加、修改、删除或搜索特定的钥匙串项目外，Apple 还提供导出和导入证书、密钥和身份的功能，甚至修改项目的访问控制。如果您想了解更多信息，请查看[钥匙串项目的文档](https://developer.apple.com/documentation/security/keychain_services/keychain_items)。

现在您已经牢牢掌握了钥匙串服务，在下一节中，您将学习如何删除包装器提供的存根方法。



## 实现 Wrapper 的 API

打开 SecureStore.swift 并在 `setValue(_:for:)` 中添加以下实现：

```swift
// 1
guard let encodedPassword = value.data(using: .utf8) else {
  throw SecureStoreError.string2DataConversionError
}

// 2
var query = secureStoreQueryable.query
query[String(kSecAttrAccount)] = userAccount

// 3
var status = SecItemCopyMatching(query as CFDictionary, nil)
switch status {
// 4
case errSecSuccess:
  var attributesToUpdate: [String: Any] = [:]
  attributesToUpdate[String(kSecValueData)] = encodedPassword
  
  status = SecItemUpdate(query as CFDictionary,
                         attributesToUpdate as CFDictionary)
  if status != errSecSuccess {
    throw error(from: status)
  }
// 5
case errSecItemNotFound:
  query[String(kSecValueData)] = encodedPassword
  
  status = SecItemAdd(query as CFDictionary, nil)
  if status != errSecSuccess {
    throw error(from: status)
  }
default:
  throw error(from: status)
}
```

顾名思义，此方法允许为特定帐户存储新密码。如果它无法更新或添加密码，它会抛出 `SecureStoreError.unhandledError`，它为它指定一个本地化描述。

这是您的代码的作用：

1. 检查它是否可以将要存储的值编码为 `Data` 类型。如果这不可能，则会引发转换错误。
2. 请求 `secureStoreQueryable` 实例执行查询并附加您要查找的帐户。
3. 返回与查询匹配的钥匙串项。
4. 如果查询成功，则表示该帐户的密码已经存在。在这种情况下，您可以使用 `SecItemUpdate(_:_:)` 替换现有密码的值。
5. 如果找不到项目，则该帐户的密码尚不存在。您可以通过调用 `SecItemAdd(_:_:)` 添加项目。

Keychain Services API 使用 Core Foundation 类型。为了让编译器满意，您必须从 Core Foundation 类型转换为 Swift 类型，反之亦然。

在第一种情况下，由于每个键的属性都是 `CFString` 类型，因此将其用作查询字典中的键需要强制转换为 String。但是，从 `[String: Any]` 到 `CFDictionary` 的转换使您能够调用 C 函数。

现在是时候找回你的密码了。滚动到您刚刚实现的方法下方，并将 `getValue(for:)` 的实现替换为以下内容：

```swift
// 1
var query = secureStoreQueryable.query
query[String(kSecMatchLimit)] = kSecMatchLimitOne
query[String(kSecReturnAttributes)] = kCFBooleanTrue
query[String(kSecReturnData)] = kCFBooleanTrue
query[String(kSecAttrAccount)] = userAccount

// 2
var queryResult: AnyObject?
let status = withUnsafeMutablePointer(to: &queryResult) {
  SecItemCopyMatching(query as CFDictionary, $0)
}

switch status {
// 3
case errSecSuccess:
  guard 
    let queriedItem = queryResult as? [String: Any],
    let passwordData = queriedItem[String(kSecValueData)] as? Data,
    let password = String(data: passwordData, encoding: .utf8)
    else {
      throw SecureStoreError.data2StringConversionError
  }
  return password
// 4
case errSecItemNotFound:
  return nil
default:
  throw error(from: status)
}
```

给定一个特定帐户，此方法检索与其关联的密码。同样，如果请求出现问题，代码会抛出 `SecureStoreError.unhandledError`。

以下是您刚刚添加的代码发生的情况：

1. 询问 `secureStoreQueryable` 以执行查询。除了添加您感兴趣的帐户外，这还使用其他属性及其相关值丰富了查询。特别是，您要求它返回单个结果，返回与该特定项目关联的所有属性，并将未加密的数据作为结果返回给您。
2. 使用 `SecItemCopyMatching(_:_:)` 执行搜索。完成后，`queryResult` 将包含对找到的 item 的引用（如果可用）。 `withUnsafeMutablePointer(to:_:)` 让您可以访问 `UnsafeMutablePointer`，您可以在闭包内使用和修改它来存储结果。
3. 如果查询成功，则表示它找到了一个项目。由于结果由包含您要求的所有属性的字典表示，因此您需要先提取数据，然后将其解码为 `Data` 类型。
4. 如果未找到项目，则返回 `nil` 值。

为帐户添加或检索密码是不够的。您还需要集成一种删除密码的方法。

找到 `removeValue(for:)` 并添加这个实现：

```swift
var query = secureStoreQueryable.query
query[String(kSecAttrAccount)] = userAccount

let status = SecItemDelete(query as CFDictionary)
guard status == errSecSuccess || status == errSecItemNotFound else {
  throw error(from: status)
}
```

要删除密码，请执行 `SecItemDelete(_:)` 指定您要查找的帐户。如果您成功删除了密码，或者没有找到任何项目，您的工作就完成了，您就可以退出了。否则，你会抛出一个未处理的错误，以便让用户知道出了问题。

但是，如果您想删除与特定服务关联的所有密码怎么办？您的下一步是实现最终代码以实现此目的。

找到 `removeAllValues()` 并在其括号内添加以下代码：

```swift
let query = secureStoreQueryable.query
  
let status = SecItemDelete(query as CFDictionary)
guard status == errSecSuccess || status == errSecItemNotFound else {
  throw error(from: status)
}
```

您会注意到，除了传递给 `SecItemDelete(_:)` 函数的查询之外，此方法与前一种方法相似。在这种情况下，您可以独立于用户帐户删除密码。

最后，构建框架以验证一切是否正确编译。



## 连接点

到目前为止，您所做的所有工作都通过添加、更新、删除和检索功能来丰富您的包装器。照原样，您必须使用符合 `SecureStoreQueryable` 的某种类型的实例来创建包装器。

由于您的第一个目标是同时处理通用密码和互联网密码，因此您的下一步是创建两种不同的配置，消费者可以创建并注入到您的包装器中。

首先，检查如何编写通用密码查询。

打开 SecureStoreQueryable.swift 并在 `SecureStoreQueryable` 定义下方添加以下代码：

```swift
public struct GenericPasswordQueryable {
  let service: String
  let accessGroup: String?
  
  init(service: String, accessGroup: String? = nil) {
    self.service = service
    self.accessGroup = accessGroup
  }
}
```

`GenericPasswordQueryable` 是一个简单的结构，它接受服务和访问组作为字符串参数。

接下来，在 `GenericPasswordQueryable` 定义下方添加以下扩展：

```swift
extension GenericPasswordQueryable: SecureStoreQueryable {
  public var query: [String: Any] {
    var query: [String: Any] = [:]
    query[String(kSecClass)] = kSecClassGenericPassword
    query[String(kSecAttrService)] = service
    // Access group if target environment is not simulator
    #if !targetEnvironment(simulator)
    if let accessGroup = accessGroup {
      query[String(kSecAttrAccessGroup)] = accessGroup
    }
    #endif
    return query
  }
}
```

要遵守 `SecureStoreQueryable` 协议，您必须将 `query` 实现为属性。查询表示您的包装器能够执行所选功能的方式。

组合查询具有特定的键和值：

* 由键 `kSecClass` 表示的项目类具有 `kSecClassGenericPassword` 值，因为您正在处理通用密码。这就是钥匙串如何推断数据是秘密的并且需要加密的。
* `kSecAttrService` 设置为使用 `GenericPasswordQueryable` 的新实例注入的服务参数值。
* 最后，如果您的代码没有在模拟器上运行，您还可以将 `kSecAttrAccessGroup` 键设置为提供的 `accessGroup` 值。这使您可以在具有相同访问权限组的不同应用程序之间共享项目。

接下来，构建框架以确保一切正常。

> 注意：对于 `kSecClassGenericPassword` 类的钥匙串项，主键是 `kSecAttrAccount` 和 `kSecAttrService` 的组合。换句话说，元组允许您唯一标识钥匙串中的通用密码。

你闪亮的新包装还没有完成！下一步是集成允许消费者与互联网密码交互的功能。

滚动到 SecureStoreQueryable.swift 的末尾并添加以下内容：

```swift
public struct InternetPasswordQueryable {
  let server: String
  let port: Int
  let path: String
  let securityDomain: String
  let internetProtocol: InternetProtocol
  let internetAuthenticationType: InternetAuthenticationType
}
```

`InternetPasswordQueryable` 是一种结构，可帮助您在应用程序钥匙串中操作 Internet 密码。

在符合 `SecureStoreQueryable` 之前，请花点时间了解您的 API 在这种情况下将如何工作。

如果用户想要处理 Internet 密码，他们会创建 `InternetPasswordQueryable` 的新实例，其中 `internetProtocol` 和 `internetAuthenticationType` 属性绑定到特定域。

接下来，将以下内容添加到您的 `InternetPasswordQueryable` 实现下方：

```swift
extension InternetPasswordQueryable: SecureStoreQueryable {
  public var query: [String: Any] {
    var query: [String: Any] = [:]
    query[String(kSecClass)] = kSecClassInternetPassword
    query[String(kSecAttrPort)] = port
    query[String(kSecAttrServer)] = server
    query[String(kSecAttrSecurityDomain)] = securityDomain
    query[String(kSecAttrPath)] = path
    query[String(kSecAttrProtocol)] = internetProtocol.rawValue
    query[String(kSecAttrAuthenticationType)] = internetAuthenticationType.rawValue
    return query
  }
}
```

正如在通用密码案例中所见，查询具有特定的键和值：

* 由键 `kSecClass` 表示的项目类具有 `kSecClassInternetPassword` 值，因为您现在正在与 Internet 密码进行交互。
* `kSecAttrPort` 设置为端口参数。
* `kSecAttrServer` 设置为服务器参数。
* `kSecAttrSecurityDomain` 设置为 `securityDomain` 参数。
* `kSecAttrPath` 设置为路径参数。
* `kSecAttrProtocol` 绑定到 `internetProtocol` 参数的 rawValue。
* 最后，`kSecAttrAuthenticationType` 绑定到 `internetAuthenticationType` 参数的 `rawValue`。

再次构建以查看 Xcode 是否正确编译。

> 注意：对于 `kSecClassInternetPassword` 类的 `keychain` 项，主键是 `kSecAttrAccount`、`kSecAttrSecurityDomain`、`kSecAttrServer`、`kSecAttrProtocol`、`kSecAttrAuthenticationType`、`kSecAttrPort` 和 `kSecAttrPath` 的组合。换句话说，这些值允许您在钥匙串中唯一标识互联网密码。

现在是时候看看你所有辛勤工作的成果了。可是等等！既然你不是在创建一个在模拟器上运行的应用程序，你将如何验证它？
这就是单元测试来拯救的地方。



## 测试行为

在本节中，您将看到如何为包装器集成单元测试。特别是，您将测试包装器公开的功能。

> 注意：如果您是单元测试的新手并且想要探索该主题，请查看我们令人惊叹的 [iOS 单元测试和 UI 测试教程](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial)。



### 创建类

```swift
import XCTest
@testable import SecureStore

class SecureStoreTests: XCTestCase {
  var secureStoreWithGenericPwd: SecureStore!
  var secureStoreWithInternetPwd: SecureStore!

  override func setUpWithError() throws {
    try super.setUpWithError()

    let genericPwdQueryable = GenericPasswordQueryable(service: "someService")
    secureStoreWithGenericPwd = SecureStore(secureStoreQueryable: genericPwdQueryable)

    let internetPwdQueryable = InternetPasswordQueryable(server: "someServer", port: 8080, path: "somePath", securityDomain: "someDomain", internetProtocol: .https, internetAuthenticationType: .httpBasic)
    secureStoreWithInternetPwd = SecureStore(secureStoreQueryable: internetPwdQueryable)
  }

  override func tearDownWithError() throws {
    try? secureStoreWithGenericPwd.removeAllValues()
    try? secureStoreWithInternetPwd.removeAllValues()

    try super.tearDownWithError()
  }

  // MARK: - 测试通用密码

  func testSaveGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
    } catch let e {
      XCTFail("Saving generic password failed with \(e.localizedDescription).")
    }
  }

  func testReadGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
      XCTAssertEqual("pwd_1234", password)
    } catch let e {
      XCTFail("Reading generic password failed with \(e.localizedDescription).")
    }
  }

  func testUpdateGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      try secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword")
      let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
      XCTAssertEqual("pwd_1234", password)
    } catch let e {
      XCTFail("Updating generic password failed with \(e.localizedDescription).")
    }
  }

  func testRemoveGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      try secureStoreWithGenericPwd.removeValue(for: "genericPassword")
      XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword"))
    } catch let e {
      XCTFail("Removing generic password failed with \(e.localizedDescription).")
    }
  }

  func testRemoveAllGenericPasswords() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      try secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword2")
      try secureStoreWithGenericPwd.removeAllValues()
      XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword"))
      XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword2"))
    } catch (let e) {
      XCTFail("Removing generic passwords failed with \(e.localizedDescription).")
    }
  }

  // MARK: - 测试互联网密码

  func testSaveInternetPassword() {
    do {
      try secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
    } catch (let e) {
      XCTFail("Saving Internet password failed with \(e.localizedDescription).")
    }
  }

  func testReadInternetPassword() {
    do {
      try secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
      let password = try secureStoreWithInternetPwd.getValue(for: "internetPassword")
      XCTAssertEqual("pwd_1234", password)
    } catch (let e) {
      XCTFail("Reading internet password failed with \(e.localizedDescription).")
    }
  }

  func testUpdateInternetPassword() {
    do {
      try secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
      try secureStoreWithInternetPwd.setValue("pwd_1235", for: "internetPassword")
      let password = try secureStoreWithInternetPwd.getValue(for: "internetPassword")
      XCTAssertEqual("pwd_1235", password)
    } catch (let e) {
      XCTFail("Updating internet password failed with \(e.localizedDescription).")
    }
  }

  func testRemoveInternetPassword() {
    do {
      try secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
      try secureStoreWithInternetPwd.removeValue(for: "internetPassword")
      XCTAssertNil(try secureStoreWithInternetPwd.getValue(for: "internetPassword"))
    } catch (let e) {
      XCTFail("Removing internet password failed with \(e.localizedDescription).")
    }
  }

  func testRemoveAllInternetPasswords() {
    do {
      try secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
      try secureStoreWithInternetPwd.setValue("pwd_1235", for: "internetPassword2")
      try secureStoreWithInternetPwd.removeAllValues()
      XCTAssertNil(try secureStoreWithInternetPwd.getValue(for: "internetPassword"))
      XCTAssertNil(try secureStoreWithInternetPwd.getValue(for: "internetPassword2"))
    } catch (let e) {
      XCTFail("Removing internet passwords failed with \(e.localizedDescription).")
    }
  }
}
```







