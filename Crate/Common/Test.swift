import Foundation

struct Test {
    static private let userID = UUID()
    
    static let album = Album(
        name: "Yeezus",
        id: "7D2NdGvBHIavgLhmcwhluK",
        artists: ["Kanye West"],
        cover_hq: URL(string: "https://i.scdn.co/image/ab67616d0000b2731dacfbc31cc873d132958af9"),
        cover_lq: URL(string: "https://i.scdn.co/image/ab67616d00001e021dacfbc31cc873d132958af9"),
        type: .album,
        date: Date.now,
        date_precision: .day,
        spotify_link: URL(string: "https://open.spotify.com/album/7D2NdGvBHIavgLhmcwhluK")!
    )
    
    static let artist = Artist(
        name: "Kanye West",
        id: "5K4W6rqBFWDnAN6FQUkS6x",
        cover_hq: URL(string: "https://i.scdn.co/image/ab6761610000e5eb6e835a500e791bf9c27a422a"),
        cover_lq: URL(string: "https://i.scdn.co/image/ab676161000051746e835a500e791bf9c27a422a")
    )
    
    static let crate = Crate(
        name: "Kanye West's Albums",
        user_id: userID.uuidString,
        cover: URL(string: "https://i.scdn.co/image/ab67616d0000b2731dacfbc31cc873d132958af9"),
        albums: ["7D2NdGvBHIavgLhmcwhluK"],
        id: UUID().uuidString
    )
    
    static let review = Review(
        album_id: "7D2NdGvBHIavgLhmcwhluK",
        title: "My Yeezus Review",
        rating: 4.5,
        description: nil
    )
    
    static let track = Track(
        name: "New Slaves",
        id: "4cAgkb0ifwn0FSHGXnr4F6",
        artists: ["Kanye West", "Frank Ocean"],
        cover: URL(string: "https://i.scdn.co/image/ab676161000051746e835a500e791bf9c27a422a"),
        album_id: "7D2NdGvBHIavgLhmcwhluK",
        index: 4
    )
    
    static let user = User(
        username: "andredavis",
        id: UUID().uuidString,
        avatar: "https://i.imgur.com/YvqV777.png"
    )
    
    static func ensureSignedOut() {
        do {
            try UserService.shared.signOut()
        } catch {
            print(error)
        }
    }
    static func signInToTestAccount() async {
        do {
            try await UserService.shared.signIn(
                email: "andredavisws@gmail.com",
                password: "abc123"
            )
        } catch {
            print(error)
        }
    }
}
