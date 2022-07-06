import SwiftUI

@main
struct DoApp: App {
    
    let dm = CoreDM.global
    
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
            ContView(viewModel: CategoryTaskViewModel(), g: geometry)
                .environment(\.managedObjectContext, dm.NSContainer.viewContext)
            }
        }
    }
}
