import UIKit
import TwitterKit
import CoreData

class Model: NSObject {
    
    class func followersList(closure: @escaping(Bool , [UserInfo]) -> Void){
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
        let params = ["user_id":  UserInfo.loadUser().userID ]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                let followUsers = UserInfo.parseUser(dic: json["users"] as! [[String : Any]])
                closure(true , followUsers)                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    
    }
    
    class func getUserTweets(userID: String! , clousre: @escaping(Bool , [TweetContent]) -> Void){
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["user_id":  userID]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                let user = json as! [Any]
                print("json: \(user)")
                let tweets = TweetContent.parsTweets(dic: user as! [[String : Any]])
                clousre(true , tweets)
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }
    
    
    class func insertUserFollowers(user: UserInfo){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserFollowers", into: context)
        
        newUser.setValue(user.userID, forKey: "userID")
        newUser.setValue(user.userName, forKey: "userName")
        newUser.setValue(user.handle, forKey: "handle")
        newUser.setValue(user.bio, forKey: "bio")
        newUser.setValue(user.userHeaderPhoto, forKey: "userHeader")
        newUser.setValue(user.userProfileImage, forKey: "userPhoto")
        
        do{
            try context.save()
            print("Done")
        }catch{
            print("Error")
        }
        
    }
    
    class func removeUsersFromEntity(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFollowers")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Deleted")
        } catch {
            print ("There was an error")
        }
    }
    
    class func selectFolowers() -> [UserInfo]{
        var userInfo = [UserInfo]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFollowers")
        request.returnsObjectsAsFaults = false
        do{
            let rows = try context.fetch(request)
            if rows.count > 0{
                for result in rows as! [NSManagedObject]{
                    let user = UserInfo()
                    if let userID = result.value(forKey: "userID") as? String{
                        user.userID = userID
                    }
                    if let userName = result.value(forKey: "userName") as? String{
                        user.userName = userName
                    }
                    if let bio = result.value(forKey: "bio") as? String{
                        user.bio = bio
                    }
                    if let handle = result.value(forKey: "handle") as? String{
                        user.handle = handle
                    }
                    if let userPhoto = result.value(forKey: "userPhoto") as? String{
                        user.userProfileImage = userPhoto
                    }
                    userInfo.append(user)
                }
            }
            
        }catch{
            print("Eorro")
        }
        
        return userInfo
    }

    
    
}
    
  
    
    

