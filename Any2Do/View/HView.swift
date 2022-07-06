import SwiftUI
import CoreData

struct HView: View {
    
    @ObservedObject var viewModel: CategoryTaskViewModel
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.taskName, ascending: false)]) var totalTask: FetchedResults<Task>
    
    
    let g: GeometryProxy
    
    @State private var isShowingCalendar = false
    @State private var isShowingCategoryEditView = false
    
    var body: some View {
        ZStack {
            if viewModel.categoryArr.count == 0 {
                TaskEView()
            }
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading,spacing: 15) {
                    Text("Список задач")
                        .font(.system(size: g.size.width/10,weight: .heavy))
                        .padding(.horizontal,25)
                    if totalTask.count == 0{
                        Text("Нет задач, давай добавим :)")
                            .font(.system(size: g.size.width/15,weight: .medium))
                            .padding(.horizontal,25)
                    }else if totalTask.count == 1{
                        Text("У тебя  \(totalTask.count) задача!")
                            .font(.system(size: g.size.width/15,weight: .medium))
                            .padding(.horizontal,25)
                    } else {
                        Text("У тебя  \(totalTask.count) задачи!")
                            .font(.system(size: g.size.width/15,weight: .medium))
                            .padding(.horizontal,25)
                    }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: g.size.width/2.5))], spacing: 40) {
                        ForEach(viewModel.categoryArr) { category in
                            NavigationLink(destination:
                                            CatDetView(viewModel: viewModel, cattask: category, g: g)
                                           , label: {
                                CatView(viewmode: viewModel, cattask: category, g: g)
                                
                            })
                        }
                    }
                    
                    .padding()
                }
            }
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    HStack(spacing: 10){
                        Button(action: {
                            //calendarview
                            isShowingCalendar = true
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("Blue"))
                                
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: g.size.width/8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .frame(width: g.size.width/5, height: g.size.width/6, alignment: .center)
                        })
                        Button(action: {
                            isShowingCategoryEditView = true
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
            }
            .padding()
        }
        .sheet(isPresented: $isShowingCalendar) {
            CalendarHView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingCategoryEditView) {
            CatEView(viewModel: viewModel, isShowingCategoryEditView: $isShowingCategoryEditView, g: g)
        }
    }
    
}
struct HomeView_Pre: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
        HView(viewModel: CategoryTaskViewModel(), g: geometry)
        }
    }
}
