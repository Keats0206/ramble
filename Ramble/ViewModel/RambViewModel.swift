//
//  RambViewModel.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase

class RambViewModel: ObservableObject {
    @Published var rambs = [Ramb]()
    
//    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
//        var tweets = [Tweet]()
//
//        REF_TWEETS.observe(.childAdded) { snapshot in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            let tweetID = snapshot.key
//
//            UserService.shared.fetchUser(uid: uid) { user in
//                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
//                tweets.append(tweet)
//                completion(tweets)
//            }
//        }
//    }
}

// Date formatter for rambles

func formatDate(timestamp: Int) -> String {
    let timestampDbl = Double(timestamp)
    let from = Date(timeIntervalSince1970: timestampDbl)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .abbreviated
    let now = Date()
    return formatter.string(from: from, to: now)!
}
