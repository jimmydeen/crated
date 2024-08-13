import Foundation

enum SpotifyAPIError: Error {
    case FailedToRetrieveAccessToken
    case InvalidResponse
    case InvalidURL
}
