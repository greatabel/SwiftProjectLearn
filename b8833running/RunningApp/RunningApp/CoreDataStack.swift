import CoreData

class CoreDataStack {
  
  static let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Running")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  static var context: NSManagedObjectContext { return persistentContainer.viewContext }
  
  class func saveContext () {
    let context = persistentContainer.viewContext
    
    guard context.hasChanges else {
      return
    }
    
    do {
      try context.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
    
    
  class func loadData() -> [NSManagedObject] {

    var myruns: [NSManagedObject] = []
    let managedContext =
        CoreDataStack.context
    
    //2
    let fetchRequest =
      NSFetchRequest<NSManagedObject>(entityName: "Run")
    
    //3
    do {
        myruns = try managedContext.fetch(fetchRequest)
        print(myruns)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return myruns
}
    
}


