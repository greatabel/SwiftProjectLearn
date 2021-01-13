import UIKit
import Foundation
import CoreData


//searchResult will store the Artworks fetched from core data
var searchResult = [Artworks]()
var context: NSManagedObjectContext?
var canRun = false
/*
 We can setup a global variable to hold detail of all of the places.
 Since we’re going to save the coordinates of a place and name of the place
 we can create an array of dictionaries each of which will contain the name,
 latitude and longitude of a place (all as strings for simplicity).
 */
struct artDescription: Decodable{
    let artworks :[Art]
}

//struct for the art structure
struct Art: Decodable {
    let id: String
    let title: String
    let artist: String
    let yearOfWork: String?
    let Information: String
    let lat: String
    let long: String
    let location: String
    let locationNotes: String
    let fileName: String
    let lastModified: String
    let enabled: String
}


//this class is used as Synchronising the app on startup,
//first check if there is data in the core data.
//second check to see if new or modified data if there is now data. new data should
//added in.
class LoadData{
    var jsonURL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artworksOnCampus/data.php?class=artworks&lastModified="
    let imageBaseURL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artwork_images/"
    
    
    //load the json file into core data
    //first need to check if data already in the core data
    public func loadJsonData(flag:Bool){

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        //deleteAll()
        
        //update the data or fetch the new data only when the internet connctivity
        //is set to true
        if flag == true{
            

        if checkDataExist() == false {
            _ = loadJasonFromURL(date: "2020-12-13")
            
        }else {
            //if data already exist and network connection is avabile then it
            //should synchronising all the data from URL. if network is not
            //avabile then it should load the unupgraded data in core data
            print("data already exist")
            synchronisingData()
        }
        //store the last update date inorder to do the synchronising
            storeLastAccessDate()
        }
        //fetch the data at the end inorder to make sure whether we have internet
        //or not we have the result loaded from core data
        //when internet is not avaliable jump right to this part
        let _ = checkDataExist()
        
    }
    
    
    //check if the data is already exist
    //if yes retuern true. if no retuen false
    //Synchronising the app on startup, to check to see if new or modified data
    func checkDataExist()->Bool{
        var flag = false
        //fetch the data from core data
        let fetchRequest:NSFetchRequest<Artworks> =
            Artworks.fetchRequest()
        do{
            //there is more than 1 pieces of data that exist.
            //return true
            searchResult = (try context?.fetch(fetchRequest))!
            if let count = searchResult.count as Int?{
            if  (count > 1) {
                flag = true
                print("data exist in is \(count)")
            } else {
                flag = false
            }
        }
        }catch{
            print("Error occured in fetching")
        }
        return flag
    }
    
    //synchronising only the changed data from URL (last update till this time)
    func synchronisingData(){

        print("updating data")
        //fetch the date from core data
        let fetchRequestDate:NSFetchRequest<LastAccessDate> =
            LastAccessDate.fetchRequest();
        //delete the last update time if necessory.
        do{
            let searchResultDate = try context?.fetch(fetchRequestDate)
                for object in searchResultDate! {
                    //pass in the previous update date to update the data
                    //in core data
                    let _ = loadJasonFromURL(date:object.lastAccessDate!)
                }
        }catch{
            print("Error occured in fetching")
        }
    }
    
    
    //get the app running date and format it into string
    func getCurrentDateString()->String{
         //fetch the current date and formate to it into yyyy-mm-dd
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = formatter.string(from: date)
        //return the righ format
        return dateString
    }
    
    //store the last update date so that next time it can be retrived.
    func storeLastAccessDate() {
        let dateString = getCurrentDateString()
        let fetchRequestDate:NSFetchRequest<LastAccessDate> =
            LastAccessDate.fetchRequest();
        do{
            
            //delete the date in core data
            let searchResultDate = try context?.fetch(fetchRequestDate)
            //iterator through the questionnaire
            if (searchResultDate?.isEmpty == false){
                
                for object in searchResultDate! {
                    print("last access date is \(object.lastAccessDate!)")
                    print("date Y/M/D amount is \(searchResultDate?.count as Any)")
                    object.lastAccessDate = dateString
                }
            } else {
                //if there is no date information in the core data
                let accessDate = NSEntityDescription.insertNewObject(forEntityName:
                    "LastAccessDate", into: context!) as? LastAccessDate
                accessDate?.lastAccessDate = dateString
            }
            
            //save the last update data
            try context?.save()
        }catch{
            print("Error occured in deletion")
        }
       
        
       

    }
    
    //load data from URL depends on the last update time
    //if last update time has been stored use then previous date
    //otherwise use November-1th
    
    func loadJasonFromURL(date:String)->Bool{
        var flag = false
        //fetch the data using the initial date time
        jsonURL = jsonURL + date
        let url = URL(string: jsonURL)
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            
            guard let data = data else{return}
            // let dataAsString = String(data: data, encoding: .utf8)
            do{
                let artDesc = try JSONDecoder().decode(artDescription.self, from: data)
                let  jsonArt = artDesc.artworks
                
                //only store the data amount is greater than 0
                if jsonArt.count > 0 {
                   self.saveIntoCoredata(artworkInstance:jsonArt)
                }
                //print(jsonArt)
                flag = true
            }catch let jsonError{
                print("Error in serializing the json file", jsonError)
            }
            
            }.resume()
        
        while(!flag){
            print("loading data")
            sleep(1)
        }
        return true
    }
    
    //save all the file into core data all at once
    func saveIntoCoredata(artworkInstance:[Art]){
        print(artworkInstance.count)
        
        //when search result is not empty means core data is not empty
        //it need to update date in core data
        //searchResult has been initislised in checkData()
        if searchResult.isEmpty == false{
            print("data already exist but need to update")
            //item in the art struct been decoded
            for item in artworkInstance{
                //object in the core data need to change to the latest one
                for object in searchResult{
                    if (object.id == Int64(item.id)){
                        let artwork = context?.object(with: object.objectID)
                            as? Artworks
                        
                        artwork?.id = Int64(item.id)!
                        artwork?.title = item.title
                        artwork?.artist = item.artist
                        //set the default 0 for the empty year of work
                        artwork?.yearOfWork = item.yearOfWork
                        artwork?.information = item.Information
                        artwork?.lat = Double(item.lat)!
                        artwork?.long = Double(item.long)!
                        artwork?.location = item.location
                        artwork?.locationNotes = item.locationNotes
                        artwork?.fileName = item.fileName
                        artwork?.lastModified = item.lastModified
                        artwork?.enabled = item.enabled
                        artwork?.imageData = loadImage(fileName:item.fileName)

                    }
                }
            }
        }else{
            //there is nothing in the core data
            print("data not exist need to initialize")
            for item in artworkInstance{
                //create new Artworks object
                let artWork = NSEntityDescription.insertNewObject(forEntityName:
                    "Artworks", into: context!) as? Artworks
                artWork?.id = Int64(item.id)!
                artWork?.title = item.title
                artWork?.artist = item.artist
                //some year of work are empty so that we can put -1 as default
                artWork?.yearOfWork = item.yearOfWork
                artWork?.information = item.Information
                artWork?.lat = Double(item.lat)!
                artWork?.long = Double(item.long)!
                artWork?.location = item.location
                artWork?.locationNotes = item.locationNotes
                artWork?.fileName = item.fileName
                artWork?.lastModified = item.lastModified
                artWork?.enabled = item.enabled
                //load the date depent on the file name
                artWork?.imageData = loadImage(fileName:item.fileName)
                
            }
        }
        
        do {
            //save after added the nsmangable object
            try context?.save()
        }catch{
            print("error in saving to core data")
        }
    }
    
    //load the image from url depend on the file name
    func loadImage(fileName:String)->NSData{
        let fullImageURL = imageBaseURL + fileName
        //change the URL replace the space to %20
        let newfullImageURL =
            fullImageURL.replacingOccurrences(of: " ",
                                              with: "%20",
                                              options: .literal,
                                              range: nil)
        //print(newfullImageURL)
        let url = URL(string: newfullImageURL)
        let data = NSData(contentsOf: url!)
        
        //let img = UIImage(data:data! as Data)
        //print(img!)
        return data!
    }
    
    //delete all the data in core data this function for testing only
    func deleteAll(){
        
        //fetch different entities from core data
        let fetchRequestArtwork:NSFetchRequest<Artworks> =
            Artworks.fetchRequest();
        
        let fetchRequestDate:NSFetchRequest<LastAccessDate> =
            LastAccessDate.fetchRequest();
        do{
            let searchResultArt = try context?.fetch(fetchRequestArtwork)
            //iterator through the questionnaire
            if (searchResultArt?.isEmpty == false){
                print(searchResultArt?.count as Any)
                for object in searchResultArt! {
                    //print(object.questionnaireID!)
                    context?.delete(object)
                }
            }
            
            //delete the date in core data
            let searchResultDate = try context?.fetch(fetchRequestDate)
            //iterator through the questionnaire
            if (searchResultDate?.isEmpty == false){
                print(searchResultDate?.count as Any)
                for object in searchResultDate! {
                    //print(object.questionnaireID!)
                    context?.delete(object)
                }
            }
            print("delete success")
            try context?.save()
            
        }catch{
            print("Error occured in deletion")
        }
    }
    
}









