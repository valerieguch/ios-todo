import Foundation
import SwiftUI
import CoreData

class CategoryTaskViewModel: ObservableObject{
    
    @Published var taskArr: [Task] = []
    @Published var categoryArr: [CategoryForTask] = []
    
    init() {
        loadAllData()
    }
    
    func loadAllData(by category: CategoryForTask? = nil) {
        loadCategory()
        if let curCategory = category {
            loadTask(by: curCategory)
        }
    }
    
    func saveAllData(by category: CategoryForTask? = nil) {
        if CoreDM.global.viewCtx.hasChanges {
            do {
                try CoreDM.global.viewCtx.save()
                loadAllData()
                if let curCategory = category {
                    loadTask(by: curCategory)
                }
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    func addNewCategory(with name: String, and iconName: String) {
        let newCat = CategoryForTask(context: CoreDM.global.viewCtx)
        
        newCat.categoryId = UUID()
        newCat.timestamp = Date()
        newCat.categoryName = name
        newCat.categoryImageName = iconName
        newCat.sumOfCategoryTask = 0
        
        saveAllData()
    }
    
    
    
    func delete(the c: CategoryForTask){
        if let tasks = c.task {
            for task in tasks {
                CoreDM.global.viewCtx.delete(task as! NSManagedObject)
            }
        }
        CoreDM.global.viewCtx.delete(c)
        saveAllData()
    }
    
    
    func loadCategory() {
        let r = NSFetchRequest<CategoryForTask>(entityName: "CategoryForTask")
        
        let sort = NSSortDescriptor(keyPath: \CategoryForTask.timestamp, ascending: true)
        
        r.sortDescriptors = [sort]
        
        do {
            try categoryArr = CoreDM.global.viewCtx.fetch(r)
        } catch {
            print("Error requesting data. \(error.localizedDescription)")
        }
    }
    
    func newCatTask(with name: String, and reminder: Date, and note: String, to cat: CategoryForTask) {
        let createdTask = Task(context: CoreDM.global.viewCtx)
        
        createdTask.taskId = UUID()
        createdTask.timestamp = Date()
        createdTask.taskName = name
        createdTask.taskReminder = reminder
        createdTask.taskNote = note
        createdTask.taskDone = false
        createdTask.taskFlag = false

        if let catIndex = categoryArr.firstIndex(where: { $0.categoryId == cat.categoryId }) {
            createdTask.category = categoryArr[catIndex]
            categoryArr[catIndex].sumOfCategoryTask = Int64(categoryArr[catIndex].task?.count ?? 0)
        }
        
        saveAllData(by: cat)
    }
    

    func loadTask(by cat: CategoryForTask) {
        if let curCatIndex = categoryArr.firstIndex(where: { $0.categoryId == cat.categoryId }) {
            let r = NSFetchRequest<Task>(entityName: "Task")
            let currentCategory = categoryArr[curCatIndex]
            
            r.predicate = NSPredicate(format:"%K == %@", "category.categoryId", currentCategory.categoryId! as CVarArg)
            
            let sort = NSSortDescriptor(keyPath: \Task.timestamp, ascending: false)
            r.sortDescriptors = [sort]
            
            do {
                try taskArr = CoreDM.global.viewCtx.fetch(r)
                categoryArr[curCatIndex].sumOfCategoryTask = Int64(categoryArr[curCatIndex].task?.count ?? 0)
                saveAllData()
            } catch {
                print("Error requesting data. \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask(by offsetsSet: IndexSet) {
        offsetsSet.map { taskArr[$0] }.forEach(CoreDM.global.viewCtx.delete)
        saveAllData()
    }
}

    
