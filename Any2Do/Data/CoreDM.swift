import Foundation
import CoreData

struct CoreDM {
    static let global = CoreDM()
    
    let NSContainer: NSPersistentContainer
    
    var viewCtx: NSManagedObjectContext {
        return NSContainer.viewContext
    }
    
    init(inMemory: Bool = false) {
        NSContainer = NSPersistentContainer(name: "Any2Do")
        NSContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let e = error as NSError? {
                fatalError("Unresolved error \(e), \(e.userInfo)")
            }
        })
        if inMemory {
            NSContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        NSContainer.viewContext.automaticallyMergesChangesFromParent = true
        
    }
}
