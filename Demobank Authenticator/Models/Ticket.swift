import Foundation

struct Ticket: Codable {
    let header: String
    let message: String
    let confirmButtonText: String
    let cancelButtonText: String
}
