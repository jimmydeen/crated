import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [IdentifiableProtocol] = []
    @Published var selectedSegment = SearchSegment.Albums
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    private var searchDelay: Int = 300
    private var querySize: Int = 12
    
    init() {
        $query
            .debounce(for: .milliseconds(searchDelay), scheduler: RunLoop.main)
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] query in
                self?.retrieveQuery(expansionQuery: false)
            }
            .store(in: &cancellables)
        
        $selectedSegment
            .sink { [weak self] segment in
                self?.retrieveQuery(expansionQuery: false)
            }
            .store(in: &cancellables)
    }
    
    public func retrieveQuery(expansionQuery: Bool) {
        if query.isEmpty {
            results = []
        } else {
            Task {
                let result = await SpotifyAPIService.retrieveSearch(
                    for: query,
                    ofType: selectedSegment,
                    from: results.count,
                    to: results.count + 12
                )
                if expansionQuery {
                    DispatchQueue.main.async { self.results.append(contentsOf: result) }
                } else {
                    DispatchQueue.main.async { self.results = result }
                }
            }
        }
    }
}
