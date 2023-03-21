import SwiftUI

// Generally, this view (as well as whole Flow) should be separated on Main and Tasks
struct TaskListView: View {
    @StateObject
    var viewModel: TaskListViewModel
    
    var body: some View {
        Text("TaskListView")
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") { viewModel.didTapLogout() }
                }
                ToolbarItem {
                    Button(
                        action: { print("Tapped") },
                        label: { Image(systemName: "plus.circle") }
                    )
                }
            }
            .onAppear { viewModel.start() }
            .navigationTitle("Tasks")
            .activityDimming($viewModel.isDimmed)
            .errorHandling($viewModel.errorAlert)
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskListView(viewModel: .init(
                logoutUseCase: DummyLogoutUseCase(),
                onFinish: {}
            ))
        }
    }
}
