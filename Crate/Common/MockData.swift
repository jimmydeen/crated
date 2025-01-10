import Foundation

struct MockData {
    static let album = AlbumModel(
        name: "More Life",
        id: "1lXY618HWkwYKJWBRYR4MK",
        artists: ["Drake"],
        cover_hq: URL(string: "https://i.scdn.co/image/ab67616d0000b2734f0fd9dad63977146e685700")!,
        cover_lq: URL(string: "https://i.scdn.co/image/ab67616d00001e024f0fd9dad63977146e685700")!,
        type: .album,
        date: .now,
        date_precision: .day,
        spotify_link: URL(string: "https://open.spotify.com/album/1lXY618HWkwYKJWBRYR4MK")!
    )
    static let artist = ArtistModel(
        name: "Drake",
        id: "3TVXtAsR1Inumwj472S9r4",
        artists: [],
        cover_hq: URL(string: "https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9")!,
        cover_lq: URL(string: "https://i.scdn.co/image/ab676161000051744293385d324db8558179afd9")!
    )
    static let list = ListModel(
        name: "Drake albums",
        user_id: UUID().uuidString,
        cover: URL(string: "https://marketplace.canva.com/EAEdeiU-IeI/1/0/1600w/canva-purple-and-red-orange-tumblr-aesthetic-chill-acoustic-classical-lo-fi-playlist-cover-jGlDSM71rNM.jpg")!,
        albums: ["1lXY618HWkwYKJWBRYR4MK", "4Q7cRXio6mF2ImVUCcezPO"],
        id: "list"
    )
    static let user = UserModel(
        name: "Andre",
        cover: nil,
        date_joined: Date.now,
        album_ratings: [:],
        favorite_albums: [],
        favorite_tracks: [:],
        friends: [],
        lists: ["list"],
        location_longitude: nil,
        location_latitude: nil,
        id: UUID().uuidString
    )
}
