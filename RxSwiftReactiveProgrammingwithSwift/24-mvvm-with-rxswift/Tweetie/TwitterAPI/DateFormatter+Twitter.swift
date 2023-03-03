import Foundation

extension DateFormatter {
  // provide formatter suitable to parse tweet dates
  static let twitter = DateFormatter(dateFormat: "EEE MMM dd HH:mm:ss Z yyyy")

  convenience init(dateFormat: String) {
    self.init()
    self.dateFormat = dateFormat
  }
}
