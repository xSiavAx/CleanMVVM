import Foundation

struct ErrorAlertContext: Identifiable {
    let id = UUID()
    
    var title = "Error"
    var details: String
    
    var retryAction: (() -> Void)?
}
