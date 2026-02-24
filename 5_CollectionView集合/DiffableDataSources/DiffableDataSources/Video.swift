
import UIKit

class Video: Hashable {
    var id = UUID()
    var title: String
    var thumbnail: UIImage?
    var lessonCount: Int
    var link: URL?

    init(title: String, thumbnail: UIImage? = nil, lessonCount: Int, link: URL?) {
        self.title = title
        self.thumbnail = thumbnail
        self.lessonCount = lessonCount
        self.link = link
    }

    // 对给定的组件执行 hash 处理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id
    }
}
