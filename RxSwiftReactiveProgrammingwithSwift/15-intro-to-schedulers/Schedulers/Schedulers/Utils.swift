import Foundation
import RxSwift

let start = Date()

private func getThreadName() -> String {
    if Thread.current.isMainThread {
        return "Main Thread"
    } else if let name = Thread.current.name {
        if name == "" {
            return "Anonymous Thread"
        }
        return name
    } else {
        return "Unknown Thread"
    }
}

private func secondsElapsed() -> String {
    return String(format: "%02i", Int(Date().timeIntervalSince(start).rounded()))
}

extension ObservableType {
    func dump() -> Observable<Element> {
        return self.do(onNext: { element in
            let threadName = getThreadName()
            print("\(secondsElapsed())s | [E] \(element) emitted on \(threadName)")
        })
    }
    
    func dumpingSubscription() -> Disposable {
        return self.subscribe(onNext: { element in
            let threadName = getThreadName()
            print("\(secondsElapsed())s | [S] \(element) received on \(threadName)")
        })
    }
}
