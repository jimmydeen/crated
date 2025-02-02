import UIKit
import SwiftUI
import Observation

@Observable class HomeViewModel {
    private let metadata: MetadataService = .shared
    
    private(set) var albums: [Album] = []

    func fetchNewReleases() async {
        guard albums.isEmpty else { return }
        
        do {
            let releases = try await metadata.fetchNewReleases(
                range: albums.count..<albums.count + 6
            )
            albums.append(contentsOf: releases)
        } catch {
            print(error)
        }
    }
}
