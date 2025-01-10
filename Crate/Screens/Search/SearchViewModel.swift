import Foundation
import Observation

public enum SearchSegment: String {
    case album, artist, track
}

@Observable class SearchViewModel {
    var query: String = "" {
        didSet {
            Task {
                await newQuery()
            }
        }
    }
    var results: [ResultProtocol] = []
    var segment = SearchSegment.album {
        didSet {
            Task {
                await newQuery()
            }
        }
    }
    
    private var isFetching: Bool = false
    
    private func newQuery() async {
        results = []
        if !query.isEmpty {
            await fetchResults()
        }
    }
    public func fetchResults() async {
        do {
            let result = try await MusicMetadataAPIService.performSearch(
                query: query,
                type: segment,
                range: results.count..<results.count + 20
            )
            results.append(contentsOf: result)
        } catch {
            print(error)
        }
    }
}
