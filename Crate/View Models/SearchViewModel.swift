import Foundation
import Observation

@Observable class SearchViewModel {
    public var query: String = "" { didSet { Task { await self.newQuery() } } }
    public var results: [IdentifiableProtocol] = []
    public var segment = SearchSegment.Albums { didSet { Task { await self.newQuery() } } }
    
    private var querySize: Int = 12
    
    private func newQuery() async {
        self.results = []
        if query == "" {
            return
        }
        await self.fetchResults()
    }
    public func fetchResults() async {
        let result = await SpotifyAPIService.retrieveSearch(
            for: query,
            ofType: segment,
            from: self.results.count,
            to: self.results.count + self.querySize
        )
        DispatchQueue.main.async {
            self.results.append(contentsOf: result)
        }
    }
}
