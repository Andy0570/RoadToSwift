/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Security

public struct SecureStore {
  let secureStoreQueryable: SecureStoreQueryable
  
  public init(secureStoreQueryable: SecureStoreQueryable) {
    self.secureStoreQueryable = secureStoreQueryable
  }

  // 添加、更新密钥
  public func setValue(_ value: String, for userAccount: String) throws {
    // 1.检查是否可以将要存储的值编码为 Data 类型
    guard let encodedPassword = value.data(using: .utf8) else {
      throw SecureStoreError.string2DataConversionError
    }

    // 2.请求 secureStoreQueryable 实例执行查询，并附加要查询的账户
    var query = secureStoreQueryable.query
    query[String(kSecAttrAccount)] = userAccount

    // 3.搜索并返回与查询匹配的钥匙串项
    var status = SecItemCopyMatching(query as CFDictionary, nil)
    switch status {
    case errSecSuccess:
      // 4.查询成功，表明该账户的密码已存在，执行更新
      var attributesToUpdate: [String: Any] = [:]
      attributesToUpdate[String(kSecValueData)] = encodedPassword

      status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
      if status != errSecSuccess {
        throw error(from: status)
      }
    case errSecItemNotFound:
      // 5.找不到匹配项，表明该账户的密码不存在，执行添加
      query[String(kSecValueData)] = encodedPassword

      status = SecItemAdd(query as CFDictionary, nil)
      if status != errSecSuccess {
        throw error(from: status)
      }
    default:
      throw error(from: status)
    }
  }

  // 获取密钥
  public func getValue(for userAccount: String) throws -> String? {
    // 询问 secureStoreQueryable 以执行查询
    var query = secureStoreQueryable.query
    query[String(kSecMatchLimit)] = kSecMatchLimitOne // 返回单个结果
    query[String(kSecReturnAttributes)] = kCFBooleanTrue // 返回与该 item 关联的所有属性
    query[String(kSecReturnData)] = kCFBooleanTrue // 返回未加密数据
    query[String(kSecAttrAccount)] = userAccount

    var queryResult: AnyObject?
    let status = withUnsafeMutablePointer(to: &queryResult) {
      SecItemCopyMatching(query as CFDictionary, $0)
    }

    switch status {
    case errSecSuccess:
      guard let queriedItem = queryResult as? [String: Any],
            let passwordData = queriedItem[String(kSecValueData)] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else {
        throw SecureStoreError.data2StringConversionError
      }
      return password
    case errSecItemNotFound:
      return nil
    default:
      throw error(from: status)
    }
  }

  // 删除指定账户密钥
  public func removeValue(for userAccount: String) throws {
    var query = secureStoreQueryable.query
    query[String(kSecAttrAccount)] = userAccount

    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw error(from: status)
    }
  }

  // 删除与特定服务关联的所有密钥
  public func removeAllValues() throws {
    let query = secureStoreQueryable.query

    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw error(from: status)
    }
  }
  
  private func error(from status: OSStatus) -> SecureStoreError {
    let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
    return SecureStoreError.unhandledError(message: message)
  }
}
