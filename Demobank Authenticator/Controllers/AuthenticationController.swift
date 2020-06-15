
import Foundation
import Combine

final class AuthenticationController: ObservableObject {

    @Published var ticket: Ticket?
    @Published var errorMessage: String?

    private let demobankService = DemobankService()

    private var cancallable: Cancellable?

    func fetchTicket(_ ticket: String) {
        cancallable = demobankService.fetchTicket(ticket).delay(for: 3.0, scheduler: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error as DemobankError):
                self?.errorMessage = error.message
            case .failure:
                self?.errorMessage = "An error occurred."
            case.finished:
                self?.errorMessage = ""
            }
        }, receiveValue: { ticket in
            self.ticket = ticket
        })
    }
}

