import CoreData
import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}



class PhotoStore {

    let imageStore = ImageStore()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores {
            (description, error) in
            if let error = error {
                print("Error setting up core data (\(error).")
            }
        }
        return container
    }()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    public func saveNewPhoto(photoID: String?, url: String?) {

//        return FlickrAPI.photos(fromJSON: jsonData, into: persistentContainer.viewContext)
        persistentContainer.performBackgroundTask{
            (context) in
            var photo = Photo(context: context)
            photo.photoID = photoID
            photo.remoteURL = URL(string: url ?? "") as NSObject?
            do {
                try context.save()
            } catch {
                print("Error saving to Core Data: \(error).")
               
                return
            }
    

        }
    }

    func processImageRequest(data: Data?, error: Error?) -> ImageResult {

        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {

                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }

        return .success(image)
    }

    func UpdateImage(photo: Photo) {
        let p: Photo!

         let fetchPhoto: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchPhoto.predicate = NSPredicate(format: "photoID = %@", (photo.photoID ?? "") as String)
        let viewContext = persistentContainer.viewContext
         let results = try? viewContext.fetch(fetchPhoto)

         if results?.count == 0 {
            // here you are inserting
            p = Photo(context: viewContext)
         } else {
            // here you are updating
            p = results?.first
         }

        p.remoteURL = photo.remoteURL

        do {
            try viewContext.save()
        } catch {
            print("Error saving to Core Data: \(error).")
           
            return
        }

        guard let photoKey = photo.photoID else {
            preconditionFailure("Photo expected to have a photoID.")
        }



        guard let photoURL = photo.remoteURL else {
//            preconditionFailure("Photo expected to have a remote URL.")
            print("no remote url")
            return
        }
//        let photoURL = photo.remoteURL
        print("photoURL->", photoURL)
        let request = URLRequest(url: photoURL as! URL)

        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in

            let result = self.processImageRequest(data: data, error: error)

            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }

          
        }
        task.resume()
    }


    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {


  
       
        
        guard let photoKey = photo.photoID else {
            preconditionFailure("Photo expected to have a photoID.")
        }


        guard let photoURL = photo.remoteURL else {
//            preconditionFailure("Photo expected to have a remote URL.")
            print("no remote url")
            return
        }
//        let photoURL = photo.remoteURL
        print("photoURL->", photoURL)
        let request = URLRequest(url: photoURL as! URL)

        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in

            let result = self.processImageRequest(data: data, error: error)

            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
        
    }

    func fetchAllPhotos(completion: @escaping (PhotosResult) -> Void) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.photoID), ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]

        let viewContext = persistentContainer.viewContext
        viewContext.performAndWait {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }


    

}
