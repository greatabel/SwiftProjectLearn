import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }


    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: NSObject?



}


