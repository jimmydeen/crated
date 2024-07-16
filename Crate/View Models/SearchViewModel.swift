import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [IdentifiableModel] = []
    @Published var selectedSegment = "albums"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newQuery in
                if self?.selectedSegment == "albums" {
                    self?.fetchAlbums()
                } else if self?.selectedSegment == "artists" {
                    self?.fetchArtists()
                } else {
                    self?.fetchTracks()
                }
            }
            .store(in: &cancellables)
        
        $selectedSegment
            .sink { [weak self] newSegment in
                self?.fetchResults()
            }
            .store(in: &cancellables)
    }
    
    public func fetchResults() {
        switch selectedSegment {
        case "albums":
            fetchAlbums()
        case "artists":
            fetchArtists()
        case "songs":
            fetchTracks()
        default:
            break
        }
    }
    
    public func refreshAlbums() {
        Task {
            let result = await SpotifyAPIService.retrieveSearch(
                for: query,
                ofType: "album",
                from: results.count,
                to: results.count + 12
            )
            DispatchQueue.main.async { self.results.append(contentsOf: result) }
        }
    }
    public func refreshArtists() {
        Task {
            let result = await SpotifyAPIService.retrieveSearch(
                for: query,
                ofType: "artist",
                from: results.count,
                to: results.count + 12
            )
            DispatchQueue.main.async { self.results.append(contentsOf: result) }
        }
    }
    public func refreshSongs() {
        Task {
            let result = await SpotifyAPIService.retrieveSearch(
                for: query,
                ofType: "track",
                from: results.count,
                to: results.count + 12
            )
            DispatchQueue.main.async { self.results.append(contentsOf: result) }
        }
    }
    
    private func fetchAlbums() {
        if query != "" {
            Task {
                self.results = await SpotifyAPIService.retrieveSearch(for: query, ofType: "album", from: 0, to: 12)
            }
        } else if !results.isEmpty {
            results = []
        }
    }
    private func fetchArtists() {
        if query != "" {
            Task {
                self.results = await SpotifyAPIService.retrieveSearch(for: query, ofType: "artist", from: 0, to: 12)
            }
        } else if !results.isEmpty {
            results = []
        }
    }
    private func fetchTracks() {
        if query != "" {
            Task {
                self.results = await SpotifyAPIService.retrieveSearch(for: query, ofType: "track", from: 0, to: 12)
            }
        } else if !results.isEmpty {
            results = []
        }
    }
}
