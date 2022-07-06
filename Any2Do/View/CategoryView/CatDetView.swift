import SwiftUI
import CoreData

struct CatDetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    let cattask: CategoryForTask
    let g: GeometryProxy
    
    @State var isShowingDetailEditView = false
    
    var body: some View {
        ZStack{
            Color("Blue")
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                CategoryDetailHeaderView(viewModel: viewModel, cat: cattask, g: g)
                
                List{
                    ForEach(viewModel.taskArr,id:\.self.taskId) { task in
                        TaskDetailsView(viewModel: viewModel, t: task, cat: cattask, g: g)
                            .navigationBarTitleDisplayMode(.inline)
                            .frame(height: 50)
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(DefaultListStyle())
                .cornerRadius(5)
            }
            .edgesIgnoringSafeArea(.bottom)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isShowingDetailEditView.toggle()
                        }
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("Purple"))
                            
                            Image(systemName: "plus")
                                .font(.system(size: g.size.width/10))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .frame(width: g.size.width/5, height: g.size.width/6, alignment: .center)
                    })
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadTask(by: cattask)
        }
        .halfSheetView(showSheet: $isShowingDetailEditView, sheetView: {
            TaskEdView(viewModel: viewModel, g: g, cattask: cattask)
        })
        .navigationBarHidden(true)
        
        
    }
    
    private func deleteTask(offsets: IndexSet) {
        viewModel.deleteTask(by: offsets)
        viewModel.loadTask(by: cattask)
    }
}

struct CategoryDetailHeaderView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    
    let cat: CategoryForTask
    let g: GeometryProxy
    
    @State private var showingAlert = false
    
    var body: some View{
        VStack {
            HStack(alignment: .bottom) {
                if let categoryDetailViewName = cat.categoryName{
                    VStack{
                        HStack{
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: g.size.width/15, weight: .semibold))
                                    .accentColor(.white)
                            })
                            Spacer()
                            Button {
                                ConstVars.hapt.rigid.impactOccurred()
                                showingAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: g.size.width/15, weight: .semibold))
                                    .foregroundColor(.pink)
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(
                                    title: Text("Подтвердите удаление"),
                                    message: Text("Вы уверены?"),
                                    primaryButton: .destructive(Text("Удалить")) {
                                        viewModel.delete(the: cat)
                                    },
                                    secondaryButton: .cancel(Text("Отмена"))
                                )
                            }
                        }
                        .padding()
                        HStack{
                            VStack(alignment: .leading,spacing: 18){
                                Text(categoryDetailViewName)
                                    .font(.system(size: g.size.width/15, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                if cat.sumOfCategoryTask <= 1 {
                                    Text("\(cat.sumOfCategoryTask) задача")
                                        .font(.system(size: g.size.width/18, weight: .medium))
                                        .foregroundColor(.white)
                                }else {
                                    Text("\(cat.sumOfCategoryTask) задач")
                                        .font(.system(size: g.size.width/18, weight: .medium))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            
                            Spacer()
                            
                            Image(systemName: cat.categoryImageName ?? " ")
                                .font(.system(size: g.size.width/6))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                    }
                }
            }
        }
    }
}


struct TaskDetailsView: View {
    
    @ObservedObject var viewModel: CategoryTaskViewModel
    let t: Task
    let cat: CategoryForTask
    let g: GeometryProxy
    
    var body: some View{
        VStack {
            HStack(alignment: .center, spacing: 20){
                Image(systemName: t.taskDone ? "checkmark" :"circle")
                    .font(.system(size: g.size.width/10, weight: .medium))
                    .padding(.vertical)
                    .foregroundColor(Color("Purple"))
                    .onTapGesture {
                        t.taskDone.toggle()
                        t.taskFlag = false
                        viewModel.saveAllData(by: cat)
                        ConstVars.hapt.medium.impactOccurred()
                    }
                    .animation(.default, value: t.taskDone)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack{
                            Image(systemName: "alarm")
                                .font(.footnote)
                            Text(taskDate(date: t.taskReminder))
                                .font(.footnote)
                                .strikethrough(t.taskDone ? true : false)
                            if t.taskNote?.count ?? 0 >= 1 {
                                Image(systemName: "message")
                                    .font(.footnote)
                            }
                        }
                        Text(t.taskName ?? "имя задачи")
                            .font(.system(size: g.size.width/15))
                            .strikethrough(t.taskDone ? true : false)
                    }
                    .foregroundColor(t.taskDone ? Color("Gray") : Color("Black") )
                    .padding(.vertical)
                    .animation(.default, value: t.taskDone)
                    
                    Spacer()
                }
                .contextMenu {
                    Text(t.taskNote ?? "Нет заметки")
                }
                
                Image(systemName: t.taskFlag ? "flag.fill" : "flag")
                    .font(.system(size: g.size.width/10))
                    .foregroundColor(t.taskFlag ? Color("Red"): Color("Black") )
                    .padding(.vertical)
                    .onTapGesture {
                        t.taskFlag.toggle()
                        viewModel.saveAllData(by: cat)
                        ConstVars.hapt.light.impactOccurred()
                    }
                    .animation(.default, value: t.taskFlag)
            }
        }
        
    }
    
    func taskDate(date: Date?) -> String{
        let form = DateFormatter()
        form.dateFormat = "YYYY-MM-dd HH:mm"
        
        let date = form.string(from: date ?? Date())
        return date
    }
}

extension View{
    
    func halfSheetView<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView:@escaping () ->SheetView) -> some View{
        
        return self
            .background(
                HalfSheetViewHelper(sheetView: sheetView(), isShowingDetailEditView: showSheet)
            )
    }
}


struct HalfSheetViewHelper<SheetView: View>: UIViewControllerRepresentable{
    var sheetView: SheetView
    @Binding var isShowingDetailEditView: Bool
    
    let controllar = UIViewController()
    func makeUIViewController(context: Context) -> UIViewController {
        controllar.view.backgroundColor = .clear
        return controllar
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShowingDetailEditView {
            let sheetController = CustomHostingController(rootView: sheetView)
            
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.isShowingDetailEditView.toggle()
                }
            }
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let prescontr = presentationController as? UISheetPresentationController{
            prescontr.detents = [
                .medium(),
                .large()
            ]
            prescontr.prefersGrabberVisible = true
        }
    }
}
