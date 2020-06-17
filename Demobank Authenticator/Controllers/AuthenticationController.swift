
import Foundation
import Combine
import UIKit

final class AuthenticationController: ObservableObject {

    @Published private(set) var authenticationTask: AuthenticationTask?

    private let demobankService = DemobankService()
    private var cancellable: Cancellable?

    func startAuthenticationFlow(with ticket: String) {
        authenticationTask = AuthenticationTask(ticket: ticket) { [weak self] in
            self?.authenticationTask = nil
        }

        authenticationTask?.startAuthenticationFlow()
    }
}

final class AuthenticationTask: ObservableObject {

    @Published private(set) var ticket: Ticket?
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool
    @Published private(set) var completeMessage: CompleteMessage?

    private(set) var token: String

    private let demobankService = DemobankService()
    private var cancellable: Cancellable?
    private let onClose: () -> Void

    fileprivate init(ticket: String, onClose: @escaping () -> Void) {
        self.onClose = onClose
        self.token = ticket
        self.isLoading = false
    }

    init(ticket: Ticket?, errorMessage: String?, isLoading: Bool, completeMessage: CompleteMessage?) {
        self.token = ""
        self.onClose = { }
        self.ticket = ticket
        self.errorMessage = errorMessage
        self.isLoading = isLoading
        self.completeMessage = completeMessage
    }

    func startAuthenticationFlow() {
        self.isLoading = true
        cancellable = demobankService.fetchTicket(token).delay(for: 3.0, scheduler: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let error as DemobankError):
                self?.errorMessage = error.message
            case .failure:
                self?.errorMessage = "An error occurred."
            case.finished:
                self?.errorMessage = nil
            }
        }, receiveValue: { ticket in
            self.ticket = ticket
            self.isLoading = false
        })
    }

    func confirmTicket() {
        self.isLoading = true
        cancellable = demobankService.confirmTicket(token).sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let error as DemobankError):
                self?.errorMessage = error.message
            case .failure:
                self?.errorMessage = "An error occurred."
            case.finished:
                self?.errorMessage = nil
            }
            }, receiveValue: { message in
                self.completeMessage = message
                self.handleCompleteMessage(message)
        })
    }

    func cancelTicket() {
        self.isLoading = true
        cancellable = demobankService.cancelTicket(token).sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let error as DemobankError):
                self?.errorMessage = error.message
            case .failure:
                self?.errorMessage = "An error occurred."
            case.finished:
                self?.errorMessage = nil
            }
            }, receiveValue: { message in
                self.completeMessage = message
                self.handleCompleteMessage(message)
        })
    }

    func finish() {
        cancellable?.cancel()
        onClose()
    }

    private func handleCompleteMessage(_ message: CompleteMessage) {
        if let url = message.url {
            if let delay = message.delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                    UIApplication.shared.open(url)
                    self.finish()
                }
            } else {
                UIApplication.shared.open(url)
                finish()
            }
        }
    }
}
