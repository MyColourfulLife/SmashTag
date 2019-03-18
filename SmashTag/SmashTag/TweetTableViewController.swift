//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by JiaShu Huang on 2019/3/11.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController {

    private var tweets = [Array<Twitter.Tweet>]()
    @IBOutlet weak var seachText: UITextField!
    
    var searchText:String? {
        didSet{
            // 每次模型变动的时候，都要告诉tableView更新UI
            tweets.removeAll()
            tableView.reloadData()
            searchForTweet()
            title = searchText
            seachText.text = searchText
            seachText.resignFirstResponder()
            lastTwitterRequest = nil
        }
    }
    
    func insertTweets(_ newTweets:[Twitter.Tweet]){
        self.tweets.insert(newTweets, at: 0)
        self.tableView?.insertSections([0], with: .fade)
    }
    
    private var lastTwitterRequest:Twitter.Request?
    private func searchForTweet(){
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                if self?.lastTwitterRequest == request {
                    DispatchQueue.main.async {
                        self?.insertTweets(newTweets)
                        self?.refreshControl?.endRefreshing()
                    }
                }else {
                    self?.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    private func twitterRequest()->Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        searchForTweet()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet:Twitter.Tweet = tweets[indexPath.section][indexPath.row]
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.description
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count-section)"
    }

}

extension TweetTableViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == seachText {
            searchText = textField.text
        }
        return true
    }
}
