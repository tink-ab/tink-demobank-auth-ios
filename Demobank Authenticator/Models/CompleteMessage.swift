import Foundation

struct CompleteMessage: Codable {
    let message: String
    let url: URL?
    let delay: Int?
}

