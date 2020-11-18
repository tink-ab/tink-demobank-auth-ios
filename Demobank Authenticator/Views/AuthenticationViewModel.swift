import Combine
import SwiftUI

extension AuthenticationView {
    final class ViewModel: ObservableObject {
        struct Button {
            let title: String
            let action: () -> Void
        }

        @Published var primaryButton: Button?
        @Published var secondaryButton: Button?
        @Published var statusText: String = ""
        @Published var isLoading = false
        @Published var color: Color = .button

        private let authenticationTask = AuthenticationTask()

        private var cancellable: Cancellable?

        init() {
            cancellable = authenticationTask.state.sink { [weak self] state in
                self?.update(state: state)
            }
        }

        init(statusText: String, primaryButton: Button?, secondaryButton: Button?, isLoading: Bool = false, color: Color = .button) {
            self.statusText = statusText
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
            self.isLoading = isLoading
            self.color = color
        }
        
        func start(with ticket: String) {
            authenticationTask.startAuthenticationFlow(ticket: ticket)
        }

        private func update(state: AuthenticationTask.State) {
            switch state {
            case .idle:
                statusText = "Waiting for authentication request..."
                primaryButton = nil
                secondaryButton = nil
                isLoading = false
                color = .button

            case .loading:
                statusText = "Loading"
                isLoading = true
                color = .button
                primaryButton = nil 
                secondaryButton = nil
                
            case .error(let error):
                statusText = error?.message ?? "An unknown error occurred"
                isLoading = false
                primaryButton = Button(title: "OK", action: { [weak task = authenticationTask] in
                    task?.reset()
                })
                secondaryButton = nil
                color = .leftToSpend

            case .complete(let complete):
                statusText = complete.message
                primaryButton = nil
                secondaryButton = nil
                isLoading = true
                color = .button

            case .ticket(let ticket):
                statusText = ticket.message
                primaryButton = Button(title: ticket.confirmButtonText, action: { [weak task = authenticationTask] in
                    task?.confirmTicket()
                })
                secondaryButton = Button(title: ticket.cancelButtonText, action: { [weak task = authenticationTask] in
                    task?.cancelTicket()
                })
                isLoading = false
                color = .button
            }
        }
    }
}
