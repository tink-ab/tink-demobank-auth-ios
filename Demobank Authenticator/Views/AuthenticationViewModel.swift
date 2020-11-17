import Combine

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

        private let authenticationTask = AuthenticationTask()

        private var cancellable: Cancellable?

        init() {
            cancellable = authenticationTask.state.sink { [weak self] state in
                self?.update(state: state)
            }
        }

        init(statusText: String, primaryButton: Button?, secondaryButton: Button?, isLoading: Bool = false) {
            self.statusText = statusText
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
            self.isLoading = isLoading
        }
        
        func start(with ticket: String) {
            authenticationTask.startAuthenticationFlow(ticket: ticket)
        }

        private func update(state: AuthenticationTask.State) {
            switch state {
            case .idle:
                statusText = "Waiting for authentication request..."
                primaryButton = nil
                secondaryButton = Button(title: "Read more about Tink Demo Bank", action: { })
                isLoading = false
            case .loading:
                statusText = "Loading"
                isLoading = true
            case .error(let error):
                statusText = error?.message ?? "An unknown error occurred"
                isLoading = false
            case .complete(let complete):
                statusText = complete.message
                primaryButton = nil
                secondaryButton = nil
                isLoading = true
            case .ticket(let ticket):
                statusText = ticket.message
                primaryButton = Button(title: ticket.confirmButtonText, action: { [weak task = authenticationTask] in
                    task?.confirmTicket()
                })
                secondaryButton = Button(title: ticket.cancelButtonText, action: { [weak task = authenticationTask] in
                    task?.cancelTicket()
                })
                isLoading = false
            }
        }
    }
}
