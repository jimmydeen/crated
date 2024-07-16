import Foundation

enum HrefError: Error {
    case MissingURL
}

enum SpotifyError: Error {
    case AuthenticationFailed
    case InvalidResponse
}
