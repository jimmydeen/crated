import Foundation
import Observation

@Observable class AddReviewViewModel: UserViewModel {
    let metadata: MetadataService = .shared
    
    var album: AlbumModel?
    var description: String = ""
    var query: String = "" {
        willSet {
            self.results.removeAll()
        }
        didSet {
            if !query.isEmpty {
                Task {
                    await fetchResults()
                }
            }
        }
    }
    var results: [AlbumModel] = []
    var tab: ReviewTab = .search
    var title: String = ""
    
    private let batchSize: Int = 20
    
    public func fetchResults() async {
        do {
            let albums = try await metadata.performSearch(
                query: query,
                type: SearchViewModel.SearchSegment.album,
                range: results.count..<results.count + batchSize
            )
            for album in albums {
                results.append(album as! AlbumModel)
            }
        } catch {
            print(error)
        }
    }
    public func selectAlbum(album: AlbumModel) {
        self.album = album
        tab = .edit
    }
    
    // MARK: Errors
    
    private enum ReviewError: Error {
        case emptyTitle, emptyDescription
    }
    
    // MARK: Tabs
    
    public enum ReviewTab {
        case search, edit, publish
    }
}
