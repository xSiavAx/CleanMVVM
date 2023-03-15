import SwiftUI

struct ErrorHandlingViewModifier: ViewModifier {
    @Binding var context: ErrorAlertContext?

    func body(content: Content) -> some View {
        if context != nil {
            content
                .alert(item: $context) { currentAlert in
                    if currentAlert.retryAction != nil {
                        return Alert(
                            title: Text(currentAlert.title),
                            message: Text(currentAlert.details),
                            primaryButton: .default(Text("Ok")),
                            secondaryButton: .default(Text("Retry"), action: currentAlert.retryAction)
                        )
                    }
                    return Alert(
                        title: Text(currentAlert.title),
                        message: Text(currentAlert.details),
                        dismissButton: .default(Text("Ok"))
                    )
                }
        } else {
            content
        }
    }
}

extension View {
    func errorHandling(_ context: Binding<ErrorAlertContext?>) -> some View {
        modifier(ErrorHandlingViewModifier(context: context))
    }
}
