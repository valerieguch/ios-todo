import SwiftUI

struct SideHView: View {
    
    @Binding var ismenu: Bool
    let g: GeometryProxy
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                withAnimation(.spring()){
                    ismenu.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: g.size.width/18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
            })
            
            VStack(alignment: .leading) {
                Image("LogoImage")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: g.size.width/5, height: g.size.width/5)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
                
                HStack {
                    Text("Планировщик")
                        .font(.system(size: g.size.width/15, weight: .heavy))
                        .padding(.bottom, 5)
                    Spacer()
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct SideHeaderView_Pre: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
        SideHView(ismenu: .constant(false), g: geometry)
            .preferredColorScheme(.dark)
        }
    }
}
