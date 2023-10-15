//
//  Authenticate.swift
//  Crate
//
//  Created by JD Chiang on 6/5/2023.
//

import Foundation


class Authenticator {
    
    static let clientID = "3df19c42306e4256863747c6f43bb7b3"
    static let clientSecret = "a94ede4677104b38a3c98333ac4c801c"
    
    static func authenticate() async throws -> String {
        
        enum SpotifyError: Error {
            case authenticationFailed
        }
        let authURL = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: authURL)
        
        request.httpMethod = "POST"
        let authData = "\(clientID):\(clientSecret)".data(using: .utf8)
        let authString = authData?.base64EncodedString()
        request.addValue("Basic \(authString ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SpotifyError.authenticationFailed
        }
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        guard let accessToken = json["access_token"] as? String else {
            throw SpotifyError.authenticationFailed
        }
        print("token:", accessToken)
        return accessToken
    }
}
