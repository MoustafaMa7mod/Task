import UIKit
import CoreData

class UserInfo: NSObject {
    
    var userName: String!
    var userID: String!
    var authToken: String!
    var authTokenSecret: String!
    var handle: String!
    var bio: String!
    var userProfileImage: String!
    var userHeaderPhoto: String!
    
    override init() {
        userName = ""
        userID = ""
        authToken = ""
        authTokenSecret = ""
        handle = ""
        bio = ""
        userProfileImage = ""
        userHeaderPhoto = ""
    }
    
    class func saveUser(user: UserInfo){
        UserDefaults.standard.set(user.userName, forKey: "userName")
        UserDefaults.standard.set(user.userID, forKey: "userID")
        UserDefaults.standard.set(user.authToken, forKey: "authToken")
        UserDefaults.standard.set(user.authTokenSecret, forKey: "authTokenSecret")
    }
    
    class func loadUser() -> UserInfo{
        var user = UserInfo()
        user.userID = UserDefaults.standard.string(forKey: "userID")
        user.userName = UserDefaults.standard.string(forKey:"userName")
        user.authToken = UserDefaults.standard.string(forKey:"authToken")
        user.authTokenSecret = UserDefaults.standard.string(forKey:"authTokenSecret")
        return user
    }
    
    class func removeUser(user: UserInfo){
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "authTokenSecret")
    }
    
    class func parseUser(dic: [[String : Any]] ) -> [UserInfo]{
        var userInfo = [UserInfo]()
        
        for i in 0..<dic.count{
            let user = UserInfo()
         
            user.userName = dic[i]["name"] as! String
            user.userID = String(dic[i]["id"] as! Int)
            user.bio = dic[i]["description"] as! String
            user.handle = dic[i]["screen_name"] as! String
            user.userProfileImage = dic[i]["profile_image_url_https"] as! String
            if let header = dic[i]["profile_banner_url"] as? String{
                user.userHeaderPhoto = header
            }
           
            insertUserFollowers(user: user)
            userInfo.append(user)
        }
        return userInfo
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
    
    class func selectFolowers(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFollowers")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let rows = try context.fetch(request)
            if rows.count > 0{
                for result in rows as! [NSManagedObject]{
                    if let userName = result.value(forKey: "userName") as? String{
                        print(userName)
                    }
                }
                
            }
            
        }catch{
            
        }
        
    }

    
    
}
