import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppFlowCoordinator!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let rootViewController = UINavigationController()
        
        window = .init(frame: UIScreen.main.bounds)
        coordinator = .init(navigationController: rootViewController)
        
        window?.rootViewController = rootViewController
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
        
        coordinator.start()
        
        return true
    }
}
