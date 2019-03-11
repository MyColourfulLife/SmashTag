//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by JiaShu Huang on 2019/3/11.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet:Twitter.Tweet? {
        didSet{updateUI()}
    }
    
    private func updateUI(){
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        if let imageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async {[weak self] in
                    if let imageData = imageData,self?.tweet?.user.profileImageURL == imageURL {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }else{
                        self?.tweetProfileImageView?.image = nil
                    }
                }
            }
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24 * 60 * 60 {
                formatter.dateStyle = .short
            }else {
                formatter.timeStyle = .short
            }
            tweetTextLabel?.text = formatter.string(from: created)
        }else {
            tweetTextLabel?.text = nil
        }
        
    }
    
}
