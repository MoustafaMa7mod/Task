import UIKit

class TweetsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var collectionMedia: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
