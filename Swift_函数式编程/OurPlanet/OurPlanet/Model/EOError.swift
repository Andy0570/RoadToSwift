import Foundation

enum EOError: Error {
	case invalidURL(String)
	case invalidParameter(String, Any)
	case invalidJSON(String)
	case invalidDecoderConfiguration
}
