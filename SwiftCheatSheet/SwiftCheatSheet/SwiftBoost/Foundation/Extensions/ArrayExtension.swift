import Foundation

public extension Array {
    /**
     SwiftBoost: Split array of elements into chunks of a size  specify. Example:
     ```
     let array = [1,2,3,4,5,6,7]
     array.chuncked(by: 3) // [[1,2,3], [4,5,6], [7]]
     ```
     
     - parameter chunkSize: Subarray size.
     */
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }

    // cell.item = items[indexPath]
    subscript(indexPath: IndexPath) -> Element {
        self[indexPath.row]
    }
}
