import Foundation
import CoreData


extension LastAccessDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastAccessDate> {
        return NSFetchRequest<LastAccessDate>(entityName: "LastAccessDate")
    }

    @NSManaged public var lastAccessDate: String?

}
