import CoreData

struct APIPreferences: Codable {
  var apiKey: String
  var baseURL: String
}

class APIPreferencesLoader {
  static private var plistURL: URL {
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documents.appendingPathComponent("myplist.plist")
  }

  static func load() -> APIPreferences {
    let decoder = PropertyListDecoder()

    guard let data = try? Data.init(contentsOf: plistURL),
      let preferences = try? decoder.decode(APIPreferences.self, from: data)
      else { return APIPreferences(apiKey: "", baseURL: "") }

    return preferences
  }
}

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


