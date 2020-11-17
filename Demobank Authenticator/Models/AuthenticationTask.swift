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

    private(set) var state: CurrentValueSubject<State, Never> 

    private let demobankService = DemobankService()
    private var cancellable: Cancellable?

    var currentTicket: String?

    init() {
        self.state = .init(.idle)
    }

    init(state: State) {
        self.state = .init(state)
    }

    func startAuthenticationFlow(ticket: String) {
        currentTicket = ticket
        state.value = .loading
        cancellable = demobankService.fetchTicket(ticket).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error as DemobankError):
                self?.state.value = .error(error)
            case .failure:
                self?.state.value = .error(nil)
            case.finished:
                break
            }
        }, receiveValue: { ticket in
            self.state.value = .ticket(ticket)
        })
    }

    func confirmTicket() {
        state.value = .loading
        guard let ticket = currentTicket else {
            fatalError()
        }

        cancellable = demobankService.confirmTicket(ticket).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error as DemobankError):
                self?.state.value = .error(error)
            case .failure:
                self?.state.value = .error(nil)
            case.finished:
                break
            }
            }, receiveValue: { message in
                self.state.value = .complete(message)
                self.handleCompleteMessage(message)
        })
    }

    func cancelTicket() {
        state.value = .loading
        guard let ticket = currentTicket else {
            fatalError()
        }
        cancellable = demobankService.cancelTicket(ticket).sink(receiveCompletion: { [weak self] completion in

            switch completion {
            case .failure(let error as DemobankError):
                self?.state.value = .error(error)
            case .failure:
                self?.state.value = .error(nil)
            case.finished:
                break
            }
            }, receiveValue: { message in
                self.state.value = .complete(message)
                self.handleCompleteMessage(message)
        })
    }

    private func handleCompleteMessage(_ message: CompleteMessage) {
        if let url = message.url {
            if let delay = message.delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                    self.currentTicket = nil
                    self.state.value = .idle
                    UIApplication.shared.open(url)
                }
            } else {
                self.currentTicket = nil
                self.state.value = .idle
                UIApplication.shared.open(url)
            }
        }
    }
}
