import Foundation

final class LoginViewModel: ObservableObject {
    @Published
    var login = "mail@siava.pp.ua"
    
    @Published
    var password = "testtest"
    
    @Published
    var isDimmed = false
    
    func didTapLogin() {
        isDimmed = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.isDimmed = false
        }
        print("Login")
    }
    
    func didTapRegister() {
        isDimmed = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.isDimmed = false
        }
    }
}
