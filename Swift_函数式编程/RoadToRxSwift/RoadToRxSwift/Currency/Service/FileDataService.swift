//
//  FileDataService.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation
import RxSwift

final class FileDataService: CurrencyServiceProtocol {

    static let shared = FileDataService()

    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
        // giving a sample json file
        guard let data = FileManager.readJson(forResource: "sample") else {
            completion(Result.failure(ErrorResult.custom(string: "No file or data")))
            return
        }

        ParserHelper.parse(data: data, completion: completion)
    }
}

// MARK: - RxSwift Version
extension FileDataService: CurrencyServiceObservable {
    func fetchConverter() -> Observable<Converter> {
        // giving a sample json file
        guard let data = FileManager.readJson(forResource: "sample") else {
            return Observable.error(ErrorResult.custom(string: "No file or data"))
        }

        return ParserHelper.parse(data: data)
    }
}


extension FileManager {

    static func readJson(forResource fileName: String ) -> Data? {

        let bundle = Bundle(for: FileDataService.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                fatalError("无法读取 sample.json 文件数据")
            }
        }

        return nil
    }
}
