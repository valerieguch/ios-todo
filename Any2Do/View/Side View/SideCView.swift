import SwiftUI

struct SideCView: View {
    
    var sideimage: String
    var sidename: String
    let g: GeometryProxy
    
    var body: some View {
        HStack(spacing:5){
            Image(systemName: sideimage)
                .font(.system(size: g.size.width/15))
                .frame(width: g.size.width/12, height: g.size.width/12)
            
            Text(sidename)
                .font(.system(size: g.size.width/20))
                .frame(width: g.size.width/5, height: g.size.width/15)
            
            Spacer()
                .frame(width:g.size.width/12)
            
            Image(systemName: "chevron.right")
                .font(.system(size: g.size.width/20))
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        
    }
}

struct SideContentView_Pre: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            SideCView(sideimage: "gearshape", sidename: "Setting", g: geometry)
            .preferredColorScheme(.dark)
        }
    }
}
