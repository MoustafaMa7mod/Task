import UIKit
import SDWebImage
import MBProgressHUD
import AVKit
import AVFoundation
import Toast_Swift



class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
   
    

    // MARK: - Outletsclass
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    var user = UserInfo()
    var userID: String!
    var userProfileImage: String!
    var userHeaderImage: String!
    var tweetUser = [TweetContent]()
    var selectedIndex = -1
    var slider = PEARImageSlideViewController()
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer: AVPlayer?
    var heightTweet: Int!
    var arrayOfIndexPath: [Int]!
    var arrayOfType: [String]!

    
    // MARK: - Main Function
    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(title: "Logout", style: .done , target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = add
        navigationItem.title = "User"
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let reachability = Reachability()!

        scrollView.contentSize = CGSize(width: 375, height: 750)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        if userHeaderImage == ""{
            headerImage.image = #imageLiteral(resourceName: "twitter-1")
        }else{
          headerImage.sd_setImage(with: URL(string: userHeaderImage))
        }
        profileImage.sd_setImage(with: URL(string: userProfileImage))
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated:true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Loading"
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                Model.getUserTweets(userID: self.userID) { (done, tweets) in
                    hud.hide(animated: true)
                    self.tweetUser = tweets
                    self.tableView.reloadData()
                }
            } else {
                Model.getUserTweets(userID: self.userID) { (done, tweets) in
                    hud.hide(animated: true)
                    self.tweetUser = tweets
                    self.tableView.reloadData()
                }
            }
        }
        reachability.whenUnreachable = { _ in
            hud.hide(animated: true)
            self.view.makeToast("No Internet Connection")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
   
 }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TweetsTableViewCell
        
        cell.tweetText.text = tweetUser[indexPath.row].tweet
        let contentSize = cell.tweetText.sizeThatFits(cell.tweetText.bounds.size)
        var frame = cell.tweetText.frame
        frame.size.height = contentSize.height
        cell.tweetText.frame = frame
        heightTweet = Int(cell.tweetText.frame.height)
        selectedIndex = indexPath.row
        cell.collectionMedia.reloadData()
        cell.collectionMedia.tag = indexPath.row
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tweetUser[indexPath.row].mediaImage.count == 0{
            return CGFloat(Int(heightTweet)) + 20
        }else{
            return 199
        }
    }
    
    // MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetUser[selectedIndex].mediaImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTweet", for: indexPath) as! MediaTweetsCollectionViewCell
        cell.mediaTweet.sd_setImage(with: URL(string: tweetUser[selectedIndex].mediaImage[indexPath.row]))
        cell.mediaTweet.layer.cornerRadius = 10
        cell.mediaTweet.clipsToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tweetUser[collectionView.tag].type == "video" || tweetUser[collectionView.tag].type == "animated_gif" {

            let videoURL = URL(string: tweetUser[collectionView.tag].videoURL)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }else  if tweetUser[collectionView.tag].type == "photo"{
            slider = PEARImageSlideViewController()
            slider.setImageLists(tweetUser[collectionView.tag].mediaImage)
            slider.show(at: indexPath.row)
        }
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
    
    
    @IBAction func headerPhotoAction(_ sender: UIButton) {
        slider = PEARImageSlideViewController()
        slider.setImageLists([userHeaderImage])
        slider.show(at: 0)
    }
    
    
    @IBAction func profilePhotoAction(_ sender: UIButton) {
        slider = PEARImageSlideViewController()
        slider.setImageLists([userProfileImage])
        slider.show(at: 0)
    }
    
    
}

