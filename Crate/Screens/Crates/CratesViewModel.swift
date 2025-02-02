import Foundation
import Observation

@Observable class CratesViewModel {
    private let user: UserService = .shared
    
    private(set) var crates: [Crate] = []
    
    func fetchCrates() async {
        guard crates.isEmpty else { return }
        
        do {
            crates = try await user.retrieveCrates()
        } catch {
            print(error)
        }
    }
}
