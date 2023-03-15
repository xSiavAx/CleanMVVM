import Foundation
import SwiftUI

struct ActivityDimmingViewModifier: ViewModifier {
    @Binding var isDimmed: Bool

    func body(content: Content) -> some View {
        if isDimmed {
            ZStack {
                content
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.6))
                .ignoresSafeArea()
            }
        } else {
            content
        }
    }
}

extension View {
    func activityDimming(_ isDimmed: Binding<Bool>) -> some View {
        modifier(ActivityDimmingViewModifier(isDimmed: isDimmed))
    }
}
