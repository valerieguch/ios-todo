import SwiftUI

struct CalendarHView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    
    @State var currentDate: Date = Date()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                ScrollView(.vertical, showsIndicators: false) {
                    CalendarDPView(viewModel: viewModel, geometry: geometry, currentDate: $currentDate)
                }
            }
        }
    }
}

struct CalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHView(viewModel: CategoryTaskViewModel())
    }
}
