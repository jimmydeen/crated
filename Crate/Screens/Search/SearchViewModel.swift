import Foundation
import Observation

@Observable class SearchViewModel {
    let metadata: MetadataService = .shared
    let querySize: Int = 20
    
    var query: String = "" {
       didSet {
           self.results.removeAll()
           if results.isEmpty {
               Task {
                   await fetchResults()
               }
           }
        }
    }
    var segment: SearchSegment = .album {
        didSet {
            self.results.removeAll()
            if results.isEmpty {
                Task {
                    await fetchResults()
                }
            }
        }
    }
    var results: [ResultProtocol] = []
    
    public func fetchResults() async {
        do {
            let count = results.count
            let results = try await metadata.performSearch(
                query: query,
                type: segment,
                range: count..<count + 1 + querySize
            )
            for result in results {
                if !self.results.contains(where: { $0.id == result.id }) {
                    self.results.append(result)
                }
            }
        } catch {
            print(error)
        }
    }
    public enum SearchSegment: String, CaseIterable {
        case album, artist, track
    }
}
