import Foundation

// this is a structure to accomodate for Twitter notion of a timeline cursor that minimizes re-fetching tweets
// 这是一个结构体，以适应 Twitter 的时间线光标概念，最大限度地减少重新获取推文的次数
// 自定义的结构，用于保存你到目前为止获取的最新和最早的 tweet ID
struct TimelineCursor {
    let maxId: Int64
    let sinceId: Int64

    init(max: Int64, since: Int64) {
        maxId = max
        sinceId = since
    }

    static var none: TimelineCursor { return TimelineCursor(max: Int64.max, since: 0) }
}

extension TimelineCursor: CustomStringConvertible {
    var description: String { return "[max: \(maxId), since: \(sinceId)]" }
}

extension TimelineCursor: Equatable {
    static func ==(lhs: TimelineCursor, rhs: TimelineCursor) -> Bool {
        return lhs.maxId==rhs.maxId && lhs.sinceId==rhs.sinceId
    }
}
