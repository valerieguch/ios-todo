import SwiftUI

struct SideMAppView: View {
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("Purple")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment:.center) {
                    HStack{
                        Text("О проекте")
                            .font(.system(size: 25,weight: .heavy))
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 10, x: 3, y: 0)
                    
                    VStack(alignment:.center, spacing: 15){
                        Image("LogoImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .padding(.vertical)
                        Text("Планировщик")
                            .font(.system(size: 20,weight: .medium))
                            .foregroundColor(.black)
                        Text("Верисия 1.0.0")
                            .foregroundColor(.black)
                        HStack{
                            Text("Приложение было разработано в рамках учебного курса по мобильной разработке Гучустян Валерией группа 191-322.")
                                .font(.system(size: 15,weight: .regular))
                                .padding(.vertical)
                        }
                    }
                    .frame(width: 335)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10, x: 3,y: 0)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            mode.wrappedValue.dismiss()
        }, label: {
            HStack{
                Image(systemName: "chevron.backward")
                    .font(.system(size: 25, weight: .semibold))
                    .accentColor(.white)
                Spacer()
            }
        }))
    }
}

struct SideMenuAppView_Pre: PreviewProvider {
    static var previews: some View {
        SideMAppView()
    }
}
