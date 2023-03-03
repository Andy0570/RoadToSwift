import UIKit

func userInputAlert(_ title: String, isSecure: Bool = false, text: String? = nil, callback: @escaping (String) -> Void) {
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    alert.addTextField(configurationHandler: { field in
        field.isSecureTextEntry = isSecure
        field.text = text
    })
    
    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        guard let text = alert.textFields?.first?.text, !text.isEmpty else {
            userInputAlert(title, callback: callback)
            return
        }
        
        callback(text)
    })
    
    let root = UIApplication.shared.keyWindow?.rootViewController
    root?.present(alert, animated: true, completion: nil)
}

