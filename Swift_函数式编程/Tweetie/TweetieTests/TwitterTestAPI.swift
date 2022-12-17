import Foundation
import XCTest
import Accounts

import RxSwift
import RxCocoa

@testable import Tweetie

class TwitterTestAPI: TwitterAPIProtocol {
    static func reset() {
        lastMethodCall = nil
        objects = PublishSubject<[JSONObject]>()
    }
    
    static var objects = PublishSubject<[JSONObject]>()
    static var lastMethodCall: String?
    
    static func timeline(of username: String) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {
        return { account, cursor in
            lastMethodCall = #function
            return objects.asObservable()
        }
    }
    
    static func timeline(of list: ListIdentifier) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {
        return { account, cursor in
            lastMethodCall = #function
            return objects.asObservable()
        }
    }
    
    static func members(of list: ListIdentifier) -> (AccessToken) -> Observable<[JSONObject]> {
        return { list in
            lastMethodCall = #function
            return objects.asObservable()
        }
    }
}
