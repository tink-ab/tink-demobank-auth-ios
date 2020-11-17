import Foundation

struct DemobankError: Error, Codable {
    let status: Int?
    let error: String?
    let message: String
    let path: String?
}
