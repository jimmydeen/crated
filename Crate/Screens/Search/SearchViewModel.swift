import Foundation
import Observation

enum SearchSegment: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case album, artist, track, user
}

@Observable class SearchViewModel {
    private let metadata: MetadataService = .shared
    
    var query: String = ""
    var segment: SearchSegment = .album
    
    private(set) var results: [SearchResult] = []
    private(set) var isLoading: Bool = false
    
    private let batchSize: Int = 20
    private var canLoadMorePages = true
    private var page: Int = 0
    
    private var searchTask: Task<Void, Never>? = nil
    
    func search() {
        searchTask?.cancel()
        searchTask = nil
        resetResults()
        
        guard !query.isEmpty else { return }
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 100_000_000)
            if Task.isCancelled { return }
            await performSearch()
        }
    }
    
    private func performSearch() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let results = try await metadata.search(
                query: query,
                type: segment,
                page: page,
                batchSize: batchSize
            )
            
            if Task.isCancelled { return }
            
            self.results += results
            
            if results.count < batchSize {
                canLoadMorePages = false
            }
            page += 1
        } catch {
            if Task.isCancelled { return }
            print(error)
        }
    }
    
    func loadMoreResults(currentItem: SearchResult) {
        guard canLoadMorePages, !isLoading else { return }
        
        if results.count >= 3, results[results.count - 3].id == currentItem.id {
            searchTask = Task {
                await performSearch()
            }
        }
    }
    
    func resetResults() {
        results.removeAll()
        canLoadMorePages = true
        page = 0
    }
}
