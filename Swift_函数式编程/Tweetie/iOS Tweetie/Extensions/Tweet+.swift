import RxDataSources

extension Tweet: IdentifiableType {
  typealias Identity = Int64
  public var identity: Int64 { return id }
}
