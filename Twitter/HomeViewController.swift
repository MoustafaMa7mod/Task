import UIKit
import SDWebImage
import TwitterKit
import MBProgressHUD

class HomeViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var user = UserInfo()
    var userFollowers = [UserInfo]()
    var heightTextViewBio: Int!
    
    
    
    //MARK: - Main Function
    override func viewDidLoad() {
        super.viewDidLoad()
          let add = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
          navigationItem.rightBarButtonItem = add
          navigationItem.title = "Followers"
          navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let reacability = Reachability()!
       self.navigationController?.isNavigationBarHidden = false
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated:true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Loading"

        
        reacability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                Model.removeUsersFromEntity()
                Model.followersList(closure: { (done, userFolloeList) in
                    hud.hide(animated: true)
                    self.userFollowers = userFolloeList
                    self.tableView.reloadData()
                })
            } else {
                Model.removeUsersFromEntity()
                Model.followersList(closure: { (done, userFolloeList) in
                    hud.hide(animated: true)
                    self.userFollowers = userFolloeList
                    self.tableView.reloadData()
                })
                
            }
        }
        reacability.whenUnreachable = { _ in
            self.userFollowers = []
            hud.hide(animated: true)
            self.userFollowers = Model.selectFolowers()
            self.tableView.reloadData()
        }
        do {
            try reacability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reacability)
//        do{
//            try reacability.startNotifier()
//        }catch{
//            print("could not start reachability notifier")
//        }

}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFollowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FollowersTableViewCell
    
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1)
        cell.selectedBackgroundView = view
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height / 2
        cell.userImage.clipsToBounds = true
        cell.userImage.sd_setImage(with: URL(string: userFollowers[indexPath.row].userProfileImage))
        cell.userName.text = userFollowers[indexPath.row].userName
        cell.userHandle.text = "@\(userFollowers[indexPath.row].handle!)"
        cell.bio.text = userFollowers[indexPath.row].bio
        
        let contentSize = cell.bio.sizeThatFits(cell.bio.bounds.size)
        var frame = cell.bio.frame
        frame.size.height = contentSize.height
        cell.bio.frame = frame
        heightTextViewBio = Int(cell.bio.frame.height)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if userFollowers[indexPath.row].bio == ""{
           return 105
        }else{
            return CGFloat(Int(105 + heightTextViewBio))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        
        viewController.userID = userFollowers[indexPath.row].userID
        viewController.userProfileImage = userFollowers[indexPath.row].userProfileImage
        viewController.userHeaderImage = userFollowers[indexPath.row].userHeaderPhoto
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Actions
    @objc func logout(){
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeNav")
        
        user.userID = UserInfo.loadUser().userID
        user.userName = UserInfo.loadUser().userName
        user.authToken = UserInfo.loadUser().authToken
        user.authTokenSecret = UserInfo.loadUser().authTokenSecret
        UserInfo.removeUser(user: user)
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    
//    @objc func reachabilityChanged(note: Notification) {
//        let reachability = note.object as! Reachability
//        switch reachability.connection {
//        case .wifi:
//            print("Reachable via WiFi")
//        case .cellular:
//            print("Reachable via Cellular")
//        case .none:
//            print("Network not reachable")
//        }
//    }
    
    
}




