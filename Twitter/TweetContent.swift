import UIKit

class TweetContent: NSObject {
    
    var tweet: String!
    var mediaImage: [String]!
    var type: String!
    var videoURL: String!
    var index: Int!

    override init() {
        tweet = ""
        mediaImage = [String]()
        type = ""
        videoURL = ""
        index = 0
    }
    
    class func parsTweets(dic: [[String: Any]]) -> [TweetContent]{
        var tweetContent = [TweetContent]()
        
        for i in 0..<dic.count{
            let tweet = TweetContent()
            tweet.tweet = dic[i]["text"] as! String
            if let entities = dic[i]["extended_entities"] as? [String: Any] {
                let extended_entities = entities
                let media =  extended_entities["media"] as! [[String: Any]]
                for j in 0..<media.count{
                    tweet.mediaImage.append(media[j]["media_url_https"] as! String)
                    if let typeMedia = media[j]["type"] as? String {
                      tweet.type = typeMedia
                    }
                    if let video = media[j]["video_info"] as? [String: Any] {
                        let video_info = video
                        let variantsVideo = video_info["variants"] as! [[String: Any]]
                        for x in 0..<variantsVideo.count{
                            tweet.videoURL = variantsVideo[x]["url"] as! String
                        }
                    }
            }
        }
        tweetContent.append(tweet)
    }
        return tweetContent
 }
    
    

}
