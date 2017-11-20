import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    // MARK: - Variables
    var user = UserInfo()
    
    
    // MARK: - Main Function
    override func viewDidLoad() {
        super.viewDidLoad()

        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                self.user.userID = (session?.userID)!
                self.user.userName = (session?.userName)!
                self.user.authToken = (session?.authToken)!
                self.user.authTokenSecret = (session?.authTokenSecret)!
                self.user.saveUser(user: self.user)
                
                
                
                
                print("signed in as \(String(describing: (session?.userName)!))");
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
