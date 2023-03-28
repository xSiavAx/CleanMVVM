import SwiftUI
import Domain

struct EditTaskView: View {
    @StateObject
    var viewModel: EditTaskViewModel
    
    var body: some View {
        Form {
            TextField("Title", text: $viewModel.task.title)
            TextEditor(text: $viewModel.task.content)
                .frame(minHeight: 200)
                .disableAutocorrection(true)
        }
        .background(Color.white)
        .toolbar {
            ToolbarItem {
                Button("Save") {
                    viewModel.didTapSave()
                }
                .disabled(!viewModel.saveEnabled)
            }
        }
        .navigationTitle(viewModel.title.rawValue)
        .activityDimming($viewModel.isDimmed)
        .errorHandling($viewModel.errorAlert)
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditTaskView(viewModel: .init(
                title: .create,
                onFinish: {}
            ))
        }
    }
}
