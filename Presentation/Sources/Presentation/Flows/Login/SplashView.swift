import SwiftUI

struct SplashView: View {
    @StateObject
    var viewModel: SplashViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear { viewModel.start() }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: .init(
            useCase: DummyCheckAuthorizationUseCase(),
            onFinish: { _ in }
        ))
    }
}
