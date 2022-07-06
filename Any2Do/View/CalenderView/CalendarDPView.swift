import SwiftUI

struct CalendarDPView: View {
    
    @ObservedObject var viewModel: CategoryTaskViewModel
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.taskReminder, ascending: true)]
    ) var allTask: FetchedResults<Task>
    
    let daysAbbrs: [String] = ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let geometry: GeometryProxy
    
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {
                    ConstVars.hapt.light.impactOccurred()
                    withAnimation{
                        currentMonth -= 1
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: geometry.size.width/15))
                })
                
                Spacer(minLength: 0)
                Text(displayMonth()[0])
                    .font(.system(size: geometry.size.width/12))
                    .fontWeight(.bold)
                Text(displayMonth()[1])
                    .font(.system(size: geometry.size.width/15))
                    .fontWeight(.semibold)
                Spacer(minLength: 0)
                
                Button(action: {
                    ConstVars.hapt.light.impactOccurred()
                    withAnimation{
                        currentMonth += 1
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: geometry.size.width/15))
                })
            }
            .padding([.vertical,.horizontal])
            
            HStack(spacing: 0) {
                ForEach(daysAbbrs, id:\.self) { day in
                    Text(day)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(extractDate()) { value in
                    CalendarCardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color("Purple"))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0 )
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            .padding(.vertical)
            
            VStack(spacing: 15) {
                Text("Задача")
                    .font(.system(size: geometry.size.width/15))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                if let calTask = allTask.filter({ t in
                    isSameDay(date1: t.taskReminder ?? Date(), date2: currentDate)
                }) {
                    ForEach(calTask) { t in
                        HStack{
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(taskDate(date:t.taskReminder))
                                    .font(.system(size: geometry.size.width/25))
                                    .foregroundColor(.white)
                                    .strikethrough(t.taskDone ? true : false)
                                Text(t.taskName ?? " ")
                                    .font(.system(size: geometry.size.width/18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .strikethrough(t.taskDone ? true : false)
                            }
                            Spacer()
                            Image(systemName: t.taskFlag ? "flag.fill" : "flag")
                                .font(.system(size: geometry.size.width/12))
                                .foregroundColor(t.taskFlag ? Color("Red"): .white )
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .background(
                            Color("Blue")
                                .opacity(0.8)
                                .cornerRadius(10)
                        )
                    }
                } else {
                    Text("Нет задач")
                }
            }
            .padding()
        }
        .onChange(of: currentMonth) { newValue in
            //update month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CalendarCardView(value: CalDate) -> some View {
        VStack {
            if value.day != -1 {
                if let t = allTask.first(where: { task in
                    return isSameDay(date1: task.taskReminder ?? Date(), date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.system(size: geometry.size.width/20))
                        .fontWeight(.semibold)
                        .foregroundColor(isSameDay(date1: t.taskReminder ?? Date(), date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: t.taskReminder ?? Date(), date2: currentDate) ? .white : Color("Purple"))
                        .frame(width: 8, height: 8)
                    
                } else {
                    Text("\(value.day)")
                        .font(.system(size: geometry.size.width/20))
                        .fontWeight(.semibold)
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    func taskDate(date: Date?) -> String{
        let fmt = DateFormatter()
        fmt.dateFormat = "YYYY-MM-dd HH:mm"
        
        let d = fmt.string(from: date ?? Date())
        return d
    }
    
    func isSameDay(date1: Date, date2: Date) ->Bool{
        let cal = Calendar.current
        return cal.isDate(date1, inSameDayAs: date2)
    }
    
    func displayMonth() -> [String] {
        let fmt = DateFormatter()
        fmt.dateFormat = "YYYY MMMM"
        let d = fmt.string(from: currentDate)
        
        return d.components(separatedBy: " ")
        
    }
    
    func getCurrentMonth() -> Date{
        let cal = Calendar.current
        guard let currentMonth = cal.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [CalDate] {
        let cal = Calendar.current
        let month = getCurrentMonth()
        
        var days = month.getAllDates().compactMap { date -> CalDate in
            let day = cal.component(.day, from: date)
            return CalDate(day: day, date: date)
        }
        
    
        let weekday = cal.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<weekday-1 {
            days.insert(CalDate(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}



extension Date {
    func getAllDates() -> [Date]{
        
        let cal = Calendar.current
        
       
        let dstart = cal.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let r = cal.range(of: .day, in: .month, for: dstart)!
        
       
        return r.compactMap{day -> Date in
            return cal.date(byAdding: .day, value: day - 1,to: dstart)!
        }
    }
}

struct CalDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHView(viewModel: CategoryTaskViewModel())
    }
}
