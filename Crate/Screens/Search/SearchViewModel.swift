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
    var results: [IdentifiableProtocol] = []
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
            let result = try await SpotifyAPIService.retrieveSearch(
                for: query,
                ofType: segment,
                from: self.results.count,
                to: self.results.count + 20
            )
            self.results.append(contentsOf: result)
        } catch {
            print(error)
        }
    }
    @MainActor public func fetchAlbumFromTrack(for albumID: String) async -> AlbumModel? {
        let album = try? await SpotifyAPIService.retrieveAlbum(for: albumID)
        return album
    }
}
