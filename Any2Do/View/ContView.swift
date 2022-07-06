import SwiftUI
import CoreData

struct ContView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var viewModel: CategoryTaskViewModel
    let g: GeometryProxy
    
    @State private var isShowingSideMenu = false
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    if isShowingSideMenu {
                        SideMView(isShowingSideMenu: $isShowingSideMenu, g: geometry)
                    }
                    HView(viewModel: viewModel, g: geometry)
                        .cornerRadius(isShowingSideMenu ? 30 : 0)
                        .scaleEffect(isShowingSideMenu ? 0.8 : 1)
                        .offset(x: isShowingSideMenu ? 250 : 0, y: isShowingSideMenu ? 45 : 0)
                        .blur(radius: isShowingSideMenu ? 2.5 : 0)
                        .opacity(isShowingSideMenu ? 0.5 : 1)
                        .allowsHitTesting(!isShowingSideMenu)
                }
                .navigationBarItems(leading: Button(action: {
                    withAnimation(.spring()) {
                        isShowingSideMenu.toggle()
                    }
                }, label: {
                    Image(systemName: "list.bullet")
                        .font(.system(size: geometry.size.width/12))
                        .foregroundColor(.gray)
                }))
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                isShowingSideMenu = false
                viewModel.loadAllData()
            }
        }
        
    }
}


struct ContentView_Pre: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
        ContView(viewModel: CategoryTaskViewModel(), g: geometry)
        }
    }
}
