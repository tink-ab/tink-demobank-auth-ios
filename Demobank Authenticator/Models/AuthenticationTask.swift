import Foundation
import Combine
import UIKit

final class AuthenticationTask {

    enum State {
        case idle
        case loading
        case error(DemobankError?)
        case ticket(Ticket)
        case complete(CompleteMessage)
    }

    @Published private(set) var state: State

    private let demobankService = DemobankService()
    private var cancellable: Cancellable?

    var currentTicket: String?

    init() {
        self.state = .idle
    }

    init(state: State) {
        self.state = state
    }

    func startAuthenticationFlow(ticket: String) {
        currentTicket = ticket
        state = .loading
        cancellable = demobankService.fetchTicket(ticket).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error as DemobankError):
                self?.state = .error(error)
            case .failure:
                self?.state = .error(nil)
            case.finished:
                break
            }
        }, receiveValue: { ticket in
            self.state = .ticket(ticket)
        })
    }

    func confirmTicket() {
        state = .loading
        guard let ticket = currentTicket else {
            fatalError()
        }

        cancellable = demobankService.confirmTicket(ticket).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error as DemobankError):
                self?.state = .error(error)
            case .failure:
                self?.state = .error(nil)
            case.finished:
                break
            }
            }, receiveValue: { message in
                self.state = .complete(message)
                self.handleCompleteMessage(message)
        })
    }

    func cancelTicket() {
        state = .loading
        guard let ticket = currentTicket else {
            fatalError()
        }
        cancellable = demobankService.cancelTicket(ticket).sink(receiveCompletion: { [weak self] completion in

            switch completion {
            case .failure(let error as DemobankError):
                self?.state = .error(error)
            case .failure:
                self?.state = .error(nil)
            case.finished:
                break
            }
            }, receiveValue: { message in
                self.state = .complete(message)
                self.handleCompleteMessage(message)
        })
    }

    func reset() {
        cancellable?.cancel()
        currentTicket = nil
        state = .idle
    }
    private func handleCompleteMessage(_ message: CompleteMessage) {
        if let url = message.url {
            if let delay = message.delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                    self.currentTicket = nil
                    self.state = .idle
                    UIApplication.shared.open(url)
                }
            } else {
                self.currentTicket = nil
                self.state = .idle
                UIApplication.shared.open(url)
            }
        }
    }
}
