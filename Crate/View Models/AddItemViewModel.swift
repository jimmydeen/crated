import Foundation
import Combine

class AddItemViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [IdentifiableProtocol] = []

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newQuery in
                self?.fetchAlbums()
            }
            .store(in: &cancellables)
    }
    
    public func refreshAlbums(for album: IdentifiableProtocol) {
        Task {
            let result = await SpotifyAPIService.retrieveSearch(
                for: query,
                ofType: SearchSegment.Albums,
                from: results.count,
                to: results.count + 12
            )
            DispatchQueue.main.async {
                self.results.append(contentsOf: result)
            }
        }
    }
    
    private func fetchAlbums() {
        if !query.isEmpty {
            Task {
                let result = await SpotifyAPIService.retrieveSearch(for: query, ofType: SearchSegment.Albums, from: 0, to: 12)
                DispatchQueue.main.async {
                    self.results = result
                }
            }
        } else if !results.isEmpty {
            results = []
        }
    }
}
