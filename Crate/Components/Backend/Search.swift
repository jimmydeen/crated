import Foundation
import Observation

@Observable class Search {
    private let batchSize: Int = 10
    private let metadata: MetadataService = .shared
    private let user: UserService = .shared
    
    var query: String = ""
    var segment: SearchSegment = .album
    
    private(set) var results: [SearchResult] = []
    private(set) var isLoading: Bool = false
    
    private var canLoadMorePages = true
    private var page: Int = 1
    
    private var searchTask: Task<Void, Never>? = nil
    
    // MARK: - Public Methods
    
    func search() {
        searchTask?.cancel()
        searchTask = nil
        results.removeAll()
        canLoadMorePages = true
        page = 1
        
        guard !query.isEmpty else { return }
        
        searchTask = Task {
            if Task.isCancelled { return }
            switch segment {
                case .user: await searchUsers()
                default: await searchMusic()
            }
        }
    }
    
    func load(currentItem: SearchResult) {
        guard canLoadMorePages, !isLoading else { return }
        
        if results.count >= 1, results[results.count - 1].id == currentItem.id {
            searchTask = Task {
                switch segment {
                    case .user: await searchUsers()
                    default: await searchMusic()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func searchMusic() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedResults = try await metadata.search(
                query: query,
                type: segment,
                page: page,
                batchSize: batchSize
            )
            
            if Task.isCancelled { return }
            
            results += fetchedResults
            
            if fetchedResults.count < batchSize {
                canLoadMorePages = false
            }
            
            page += 1
        } catch {
            if Task.isCancelled { return }
            print(error)
        }
    }
    
    private func searchUsers() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedResults = try await user.searchUsers(
                query: query,
                page: page,
                batchSize: batchSize
            )
            
            if Task.isCancelled { return }
            
            results += fetchedResults
            
            if fetchedResults.count < batchSize {
                canLoadMorePages = false
            }
            
            page += 1
        } catch {
            if Task.isCancelled { return }
            print(error)
        }
    }
}

enum SearchSegment: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case album, artist, track, user
}
