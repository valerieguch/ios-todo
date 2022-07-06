import SwiftUI

struct SideMView: View {
    
    @Binding var isShowingSideMenu: Bool
    let g: GeometryProxy
    
    var body: some View {
        ZStack{
            MotionAView()
           
            VStack(alignment: .leading, spacing: 2) {
                SideHView(ismenu: $isShowingSideMenu, g: g)
                    .frame(height: 200)
                
                NavigationLink(destination: {
                    SideMGView()
                }, label: {
                    SideCView(sideimage: "book", sidename: "Гид", g: g)
                })
              
                NavigationLink(destination: {
                    SideMAppView()
                }, label: {
                    SideCView(sideimage: "ellipsis.circle", sidename: "О проекте", g: g)
                })
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}

struct SideMenuView_Pre: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            SideMView(isShowingSideMenu: .constant(false), g: geometry)
        }
    }
}
