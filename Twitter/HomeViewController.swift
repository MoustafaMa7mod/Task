import UIKit
import SDWebImage

class HomeViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    //MARK: - Variables
    var user = UserInfo()
  
    
    //MARK: - Main Function
    override func viewDidLoad() {
        super.viewDidLoad()
          let add = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
          navigationItem.rightBarButtonItem = add
          navigationItem.title = "Home"
          navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FollowersTableViewCell

        cell.userImage.sd_setImage(with: URL(string: "" ))
        cell.userName.text = "Mostafa"
        cell.userHandle.text = "@Doc"
        cell.bio.text = "55dfdds5fdsdfds45fsdfds5fd"
        
        return cell
    }
    
    
    //MARK: - Actions
    @objc func logout(){
        
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeNav")
        user.userID = user.loadUser().userID
        user.userName = user.loadUser().userName
        user.authToken = user.loadUser().authToken
        user.authTokenSecret = user.loadUser().authTokenSecret
        self.user.removeUser(user: user)
        self.present(viewController, animated: true, completion: nil)
    }
}
