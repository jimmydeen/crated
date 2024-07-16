import Foundation
import Combine

class AddItemViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [IdentifiableModel] = []

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
    
    public func refreshAlbums() {
        Task {
            let result = await SpotifyAPIService.retrieveSearch(
                for: query,
                ofType: "album",
                from: results.count,
                to: results.count + 12
            )
            DispatchQueue.main.async {
                self.results.append(contentsOf: result)
            }
        }
    }
    
    private func fetchAlbums() {
        if query != "" {
            Task {
                let result = await SpotifyAPIService.retrieveSearch(for: query, ofType: "album", from: 0, to: 12)
                DispatchQueue.main.async {
                    self.results = result
                }
            }
        } else if !results.isEmpty {
            results = []
        }
    }
}
