import SwiftUI

struct SideMGView: View {
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("Purple")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment:.center) {
                    HStack{
                    Text("Гид")
                        .font(.system(size: 25,weight: .heavy))
                        .foregroundColor(.black)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 10, x: 3, y: 0)
                    VStack(alignment: .leading){
                        Text("1. Создайте категорию: введите имя и выберите иконку.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Image-1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                        Text("2. Создайте задачу: введите имя, выберите время. Можно также добавить заметку.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Image-2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                        Text("3. Можно завершить задачу или отметить ее. Долго нажатие покажет заметки.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Image-3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                        Text("4. Все задачи можно посмотреть в календаре.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Image-4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                    }
                    .frame(width: 335)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10, x: 3,y: 0)
                }
                .padding()
            }
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

struct SideMenuAboutView_Pre: PreviewProvider {
    static var previews: some View {
        SideMGView()
    }
}
