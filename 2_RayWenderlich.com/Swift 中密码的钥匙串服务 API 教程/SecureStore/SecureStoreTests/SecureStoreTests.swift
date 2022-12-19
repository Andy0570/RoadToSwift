/// Copyright (c) 2022 Razeware LLC
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
      XCTAssertEqual("pwd_1235", password)
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
