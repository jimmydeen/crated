import Foundation

enum SpotifyAPIError: Error {
    case FailedToRetrieveAccessToken, InvalidResponse, InvalidURL
}
