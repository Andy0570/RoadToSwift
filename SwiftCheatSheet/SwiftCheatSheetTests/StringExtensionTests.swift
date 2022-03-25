//
//  StringExtensionTests.swift
//  SwiftCheatSheetTests
//
//  Created by Qilin Hu on 2022/3/25.
//

import XCTest
@testable import SwiftCheatSheet

class StringExtensionTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // 测试计算字符串的 MD5 哈希值
    func testGenerateMD5Value() {
        let password = "1234567890"
        guard let passwordMD5 = password.md5 else {
            XCTFail("计算字符串的 MD5 哈希值失败")
            return
        }
        // OpenSSL command：
        // $ echo -n 1234567890 | openssl md5
        XCTAssertEqual(passwordMD5, "e807f1fcf82d132f9bb018ca6738a19f")
    }

    // JSON -> Dictionary
    func testParsingJSONFromString() {
        // given
        let json = "{\"surname\":\"Doe\",\"name\":\"John\",\"age\":31}"
        // when
        if let restoredDict = json.jsonToDictionary() {
            // then
            XCTAssertNotNil(restoredDict)
        }
    }

    // Dictionary -> JSON
    func testDictionaryEncodingToJSON() {
        // given
        let dictionary: [String: Any] = [
            "name": "John",
            "surname": "Doe",
            "age": 31
        ]
        // when
        if let json = String(json: dictionary) {
            // then
            XCTAssertNotNil(json)
        }
    }
}
