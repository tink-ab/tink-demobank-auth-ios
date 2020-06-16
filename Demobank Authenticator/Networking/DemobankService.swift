import Foundation
import Combine

final class DemobankService {

    private let urlSession: URLSession = .shared
    private let decoder = JSONDecoder()
    private let baseUrl = URL(string: "https://demobank.production.global.tink.se/api")!

    func fetchTicket(_ ticket: String) -> AnyPublisher<Ticket, Error> {
        let urlRequest = URLRequest(url: baseUrl.appendingPathComponent("auth/ticket/\(ticket)"))
        return performRequest(urlRequest: urlRequest)
    }

    func cancelTicket(_ ticket: String) -> AnyPublisher<CompleteMessage, Error> {
        let urlRequest = URLRequest(url: baseUrl.appendingPathComponent("auth/ticket/\(ticket)/cancel"))
        return performRequest(urlRequest: urlRequest)
    }

    func confirmTicket(_ ticket: String) -> AnyPublisher<CompleteMessage, Error> {
        let urlRequest = URLRequest(url: baseUrl.appendingPathComponent("auth/ticket/\(ticket)/confirm"))
        return performRequest(urlRequest: urlRequest)
    }

    private func performRequest<Object: Decodable>(urlRequest: URLRequest) -> AnyPublisher<Object, Error> {
        return urlSession.dataTaskPublisher(for: urlRequest)
        .tryMap { element -> Data in
            guard let response = element.response as? HTTPURLResponse, response.statusCode == 200 else {
                if let errorBody = try? self.decoder.decode(DemobankError.self, from: element.data) {
                    throw errorBody
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            return element.data
        }
        .decode(type: Object.self, decoder: decoder)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
