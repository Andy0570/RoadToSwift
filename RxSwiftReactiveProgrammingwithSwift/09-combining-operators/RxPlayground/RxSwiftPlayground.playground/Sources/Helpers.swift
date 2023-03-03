import Foundation

public class Example {
    public static var beforeEach: ((String) -> ())? = nil

    public static func of(_ description: String, action: () -> ()) {
        beforeEach?(description)
        printHeader(description)
        action()
    }

    private static func printHeader(_ message: String) {
        print("\nℹ️ \(message):")
        let length = Float(message.count + 3) * 1.2
        print(String(repeating: "—", count: Int(length)))
    }
}

public func example(of description: String, action: () -> Void) {
	print("\n——— Example of:", description, "———")
	action()
}
