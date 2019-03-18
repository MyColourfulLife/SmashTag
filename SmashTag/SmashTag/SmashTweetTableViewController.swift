//
//  SmashTweetTableViewController.swift
//  SmashTag
//
//  Created by JiaShu Huang on 2019/3/13.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    var container:NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets:[Twitter.Tweet]){
        super.insertTweets(newTweets)
        updateDatabase(with:newTweets)
    }
    private func updateDatabase(with tweets:[Twitter.Tweet]){
        container?.performBackgroundTask{ [weak self] context in
            for twitterInfo in tweets {
               _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
    }
    private func printDatabaseStatistics(){
        if let context = container?.viewContext {
            context.perform {
                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count {
                    print("\(tweetCount) tweets")
                }
            }
            // a better way
            if let tweetersCount = try? context.count(for: TwitterUser.fetchRequest()) {
                print("\(tweetersCount) twitter users")
            }
        }
    }
}
