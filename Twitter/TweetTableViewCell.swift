//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Aldo Socarras on 2/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorited: Bool = false
    var retweeted: Bool = false
    var tweetId: Int = -1
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if toBeFavorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        let toBeRetweeted = !retweeted
        if toBeRetweeted {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                    self.setRetweeted(true)
                }, failure: { (Error) in
                    print("Retweeting did not succeed: \(Error)")
                })
        } else {
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {
                    self.setRetweeted(false)
                }, failure: { (Error) in
                    print("Undo retweeting did not succeed: \(Error)")
                })
        }
    }
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if favorited {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool) {
        if isRetweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/3
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
