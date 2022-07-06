import SwiftUI
import CoreData

struct CatView: View {
    
    @ObservedObject var viewmode: CategoryTaskViewModel
    let cattask: CategoryForTask
    let g: GeometryProxy
    
    var body: some View {
        if let categoryName = cattask.categoryName{
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4)
                
                VStack(alignment:.leading) {
                    Text(categoryName)
                        .foregroundColor(.black)
                        .font(.system(size: g.size.width/15))
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image(systemName: cattask.categoryImageName ?? "wallet.pass")
                            .font(.system(size: g.size.width/12))
                            .foregroundColor(.black)
                        Spacer()
                        if cattask.sumOfCategoryTask <= 1{
                            VStack(alignment:.leading){
                                Text("\(cattask.sumOfCategoryTask)")
                                Text("задача")
                            }
                            .font(.system(size: g.size.width/20))
                            .foregroundColor(.gray)
                        }else {
                            VStack(alignment:.leading){
                                Text("\(cattask.sumOfCategoryTask)")
                                Text("задачи")
                            }
                            .font(.system(size: g.size.width/20))
                            .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
            }
            .frame(width: g.size.width/2.4, height: g.size.width/5)
        }
    }
}



