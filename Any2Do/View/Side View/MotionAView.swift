import SwiftUI

struct MotionAView: View {
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("Purple")]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
            .drawingGroup()
            .ignoresSafeArea(.all, edges: .all)
        }
    }
}

struct MotionAView_Previews: PreviewProvider {
    static var previews: some View {
        MotionAView()
    }
}
