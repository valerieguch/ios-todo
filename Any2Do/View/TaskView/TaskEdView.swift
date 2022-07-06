import SwiftUI
import CoreData

struct TaskEdView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    
    @State var taskEditName = ""
    @State var reminderEditTime = Date.now
    @State var taskNote = ""
    
    @State var errorShowing = false
    @State var errorTitle = ""
    @State var errorMessage = ""
    
    var dataver: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -100, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 100, to: Date())!
        return min...max
    }
    
    let g: GeometryProxy
    let cattask: CategoryForTask
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: g.size.width/15, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        ConstVars.hapt.heavy.impactOccurred()
                        if self.taskEditName != "" {
                            viewModel.newCatTask(with: taskEditName, and: reminderEditTime, and: taskNote, to: cattask)
                            print("сохранить новую задачу：\(taskEditName), \(reminderEditTime), заметка: \(taskNote)")
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Неверное имя"
                            self.errorMessage = "Подтвердите имя задачи"
                            return
                        }
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: g.size.width/15, weight: .semibold))
                            .foregroundColor(Color("Black"))
                            .padding()
                    })
                }
                Spacer()
                
                VStack(alignment:.center){
                    
                    TextField("Имя задачи", text: $taskEditName)
                        .font(.system(size: g.size.width/12, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .keyboardType(.namePhonePad)
                        .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading,spacing: 10) {
                            HStack {
                                Image(systemName: "bell.badge")
                                    .font(.system(size: g.size.width/18))
                                Text("Напоминание")
                                    .font(.system(size: g.size.width/18))
                                    .padding(.vertical)
                            }
                            .padding(.horizontal)
                            DatePicker(selection: $reminderEditTime,in:dataver,displayedComponents: [.hourAndMinute,.date], label: {Text("Дата")})
                                .padding()
                            HStack{
                                Image(systemName: "text.bubble")
                                    .font(.system(size: g.size.width/18))
                                Text("Заметка")
                                    .font(.system(size: g.size.width/18))
                                    .padding(.vertical)
                            }
                            .padding(.horizontal)
                            TextField("Напишите что-нибудь...", text: $taskNote)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                
                        }
                    }
                }
            }
            
            
        }
        .alert(isPresented: $errorShowing) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}
