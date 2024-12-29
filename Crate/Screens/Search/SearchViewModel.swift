import Foundation
import Observation

@Observable class SearchViewModel {
    var query: String = "" {
        didSet {
            Task {
                await self.newQuery()
            }
        }
    }
    var results: [ResultProtocol] = []
    var segment = SearchSegment.Albums {
        didSet {
            Task {
                await self.newQuery()
            }
        }
    }
    
    @MainActor private func newQuery() async {
        self.results = []
        if query.isEmpty {
            return
        }
        await self.fetchResults()
    }
    @MainActor public func fetchResults() async {
        do {
            let result = try await SpotifyAPIService.performSearch(
                query: self.query,
                type: self.segment,
                range: self.results.count..<self.results.count + 20
            )
            self.results.append(contentsOf: result)
        } catch {
            print(error)
        }
    }
    @MainActor public func fetchAlbumFromTrack(for albumID: String) async -> AlbumModel? {
        let album = try? await SpotifyAPIService.fetchAlbumDetails(albumID: albumID)
        return album
    }
}
