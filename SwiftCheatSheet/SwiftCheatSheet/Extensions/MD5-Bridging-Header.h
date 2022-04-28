//
//  MD5-Bridging-Header.h
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/25.
//

#ifndef MD5_Bridging_Header_h
#define MD5_Bridging_Header_h

/// MARK: - 手动创建桥接头文件（Bridging Header）
/// 由于 CommonCrypto 并不是一个独立的模块，因此不能直接使用 import CommonCrypto 导入。
/// 步骤：打开 Build Settings -> Swift Compiler - General，设置 Objective-C Bridging Header 文件路径：
/// $(SRCROOT)/SwiftCheatSheet/Extensions/MD5-Bridging-Header.h
/// #import <CommonCrypto/CommonCrypto.h>
/// Update: Swift 5 之后，你可以直接 import CommonCrypto

#endif /* MD5_Bridging_Header_h */
