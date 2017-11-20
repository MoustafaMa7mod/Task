import UIKit

struct UserInfo {

    var userName: String!
    var userID: String!
    var authToken: String!
    var authTokenSecret: String
    
    init() {
        userName = ""
        userID = ""
        authToken = ""
        authTokenSecret = ""
    }
    
    func saveUser(user: UserInfo){
        UserDefaults.standard.set(user.userName, forKey: "userName")
        UserDefaults.standard.set(user.userID, forKey: "userID")
        UserDefaults.standard.set(user.authToken, forKey: "authToken")
        UserDefaults.standard.set(user.authTokenSecret, forKey: "authTokenSecret")
    }
    
    func loadUser() -> UserInfo{
        var user = UserInfo()
        user.userID = UserDefaults.standard.string(forKey: "userID")
        user.userName = UserDefaults.standard.string(forKey:"userName")
        user.authToken = UserDefaults.standard.string(forKey:"authToken")
        user.authTokenSecret = UserDefaults.standard.string(forKey:"authTokenSecret")!
        return user
    }
    
    func removeUser(user: UserInfo){
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "authTokenSecret")
    }
    
    

    
    
}
