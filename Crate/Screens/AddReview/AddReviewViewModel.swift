import Foundation
import Observation

@Observable class AddReviewViewModel: UserViewModel {
    private let metadata: MetadataService = .shared
    private let batchSize: Int = 20
    
    private var page: Int = 0
    
    var album: AlbumModel?
    var description: String = ""
    var query: String = "" {
        didSet {
            self.albums.removeAll()
            if !query.isEmpty {
                Task {
                    await fetchResults()
                }
            }
        }
    }
    var albums: [AlbumModel] = []
    var tab: ReviewTab = .search
    var title: String = ""
    
    // MARK: Fetch Results
    
    public func fetchResults() async {
        do {
            let albums = try await metadata.search(
                query: query,
                type: .album,
                page: page,
                batchSize: batchSize
            )
            for album in albums {
                self.albums.append(album as! AlbumModel)
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
