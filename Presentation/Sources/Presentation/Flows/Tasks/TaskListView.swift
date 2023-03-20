import SwiftUI

struct TaskListView: View {
    @StateObject
    var viewModel: TaskListViewModel
    
    var body: some View {
        Text("TaskListView")
            .background(Color.white)
            .onAppear { viewModel.start() }
            .navigationTitle("Tasks")
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: .init())
    }
}
