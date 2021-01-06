import Foundation
import CoreData


extension Artworks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artworks> {
        return NSFetchRequest<Artworks>(entityName: "Artworks")
    }

    @NSManaged public var artist: String?
    @NSManaged public var distance: Double
    @NSManaged public var enabled: String?
    @NSManaged public var fileName: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageData: NSData?
    @NSManaged public var information: String?
    @NSManaged public var lastModified: String?
    @NSManaged public var lat: Double
    @NSManaged public var location: String?
    @NSManaged public var locationNotes: String?
    @NSManaged public var long: Double
    @NSManaged public var title: String?
    @NSManaged public var yearOfWork: String?

}
