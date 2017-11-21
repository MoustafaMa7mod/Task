import UIKit
import TwitterKit

class Model: NSObject {
    
    class func followersList(closure: @escaping(Bool , [UserInfo]) -> Void){
        let client = TWTRAPIClient()
        var followUsers = [UserInfo]()
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
                print("json: \(json)")
                followUsers = UserInfo.parseUser(dic: json["users"] as! [[String : Any]])
                closure(true , followUsers)
//                print("dic:  \(followUsers)")
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    
    }
        
        
        
}
    
  
    
    

