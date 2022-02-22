//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Aldo Socarras on 2/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import Lottie

class HomeTableTableViewController: UITableViewController {

    let _refreshControl = UIRefreshControl()
    let baseUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    var requestParams = ["count": 20]
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets = 20
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start loading animation
        startAnimation()
        // Load list of tweets from signed-in user
        loadTweets()
        // Set up pull-to-refresh action
        _refreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        // Let the TableView know which refreshControl is ours
        tableView.refreshControl = _refreshControl
        // Stop loading animation
        stopAnimation()
    }
    
    @objc func loadTweets() {
        numberOfTweets = 20
        requestParams.updateValue(numberOfTweets, forKey: "count")
        
        TwitterAPICaller.client?.getDictionariesRequest(url: baseUrl, parameters: requestParams, success: { (tweets: [NSDictionary]) in
            
            // Clear the tweet array before adding new tweets
            self.tweetArray.removeAll()
            // Add tweets into an array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            // Reload data with our fetched API content
            self.tableView.reloadData()
            // Stop refresh icon after reloading data
            self._refreshControl.endRefreshing()
        }, failure: { Error in
            print("Error: " + Error.localizedDescription)
        })
    }
    
    func loadMoreTweets() {
        numberOfTweets += 20
        requestParams.updateValue(numberOfTweets, forKey: "count")
        
        TwitterAPICaller.client?.getDictionariesRequest(url: baseUrl, parameters: requestParams, success: { (tweets: [NSDictionary]) in
            
            // Clear the tweet array before adding new tweets
            self.tweetArray.removeAll()
            // Add tweets into an array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            // Reload data with our fetched API content
            self.tableView.reloadData()
        }, failure: { Error in
            print("Error: " + Error.localizedDescription)
        })
    }
    
    func startAnimation() {
        animationView = .init(name: "96209-timer")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        view.addSubview(animationView!)
        animationView!.loopMode = .loop
        animationView!.play()
    }
    
    func stopAnimation() {
        animationView?.stop()
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: USER_LOGGED_IN)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        // Set user's name
        cell.userNameLabel.text = user["name"] as? String
        // Set tweet content/body
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        // Set profile image
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == tweetArray.count - 5) {
            loadMoreTweets()
        }
    }
    
}
