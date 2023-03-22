import SwiftUI
import Domain

struct TaskListView: View {
    @StateObject
    var viewModel: TaskListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.tasks) { row in
                HStack {
                    Text(row.title)
                    Spacer()
                    statusButton(status: row.status) {
                        viewModel.didTapStatus(taskID: row.id, status: row.status)
                    }
                }
            }
            .onDelete { viewModel.deleteTasks(at: $0) }
        }
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
    
    private func statusButton(
        status: TodoTask.Status,
        action: @escaping () -> Void
    ) -> some View {
        return Button(status.rawValue, action: action)
            .asStatus(status: status)
    }
}

fileprivate extension Button {
    func asStatus(status: TodoTask.Status) -> some View {
        return font(.caption)
            .padding(4)
            .border(status.color, width: 1)
            .cornerRadius(2)
            .foregroundColor(status.color)
            .buttonStyle(.plain)
    }
}

fileprivate extension TodoTask.Status {
    var color: Color {
        switch self {
        case .todo: return .red
        case .inProgress: return .yellow
        case .done: return .green
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskListView(viewModel: .forPreview())
        }
    }
}
