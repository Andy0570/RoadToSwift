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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

/// 这是面向协议编程和依赖注入的强大功能和灵活性的一个很好的例子
/// 通过将数据获取服务作为依赖项传递到 TubeStatusViewModel，很容易用不同的实现替换数据的获取方式。
/// 通过将数据获取服务作为依赖项传递到 TubeStatusViewModel，很容易用不同的实现替换数据的获取方式。

enum TubeLinesStatusFetcherFactory {
    // 2
    static func new() -> TubeLinesStatusFetcher {
        // 如果在调试模式下运行并且 USE_DEBUG_DATA 设置为 true，则返回之前创建的 DebugDataService 实例
        // Edit Scheme -> Run -> Environment Variables -> 添加 USE_DEBUG_DATA 值为 true
        #if DEBUG
        if ProcessInfo.processInfo.environment["USE_DEBUG_DATA"] == "true" {
            return DebugDataService()
        }
        #endif
        // 否则，返回一个 TransportAPIService 实例，它从 Transport API 中获取真实数据。
        return TransportAPIService()
    }
}
