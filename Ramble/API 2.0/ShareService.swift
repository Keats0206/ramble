//
//  SocialShareService.swift
//  Ramble
//
//  Created by Peter Keating on 11/20/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import AVKit
import Photos
import SwiftUI
import UIKit
import SwiftVideoGenerator


public class ShareService: ObservableObject {
    static let shared = ShareService()
//    func instagramStoriesPhoto() {
//        if let urlScheme = URL(string: "instagram-stories://share") {
//            // 2
//            if UIApplication.shared.canOpenURL(urlScheme) {
//                // 3
//                let imageData: Data = UIImage(imageLiteralResourceName: "experienced").pngData()!
//                // 4
//                let items = [["com.instagram.sharedSticker.backgroundImage": imageData]]
//                let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]
//                // 5
//                UIPasteboard.general.setItems(items, options: pasteboardOptions)
//                // 6
//                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
//            }
//        }
//    }
    
// Concert this to accept a video url
    func createVideoWithAudio(fileName: String, image: UIImage, audio: URL){
          VideoGenerator.fileName = "filename"
          VideoGenerator.shouldOptimiseImageForVideo = true
          VideoGenerator.current.generate(withImages: [image], andAudios: [audio], andType: .single, { (progress) in
            print(progress)
          }, outcome: { (url) in
            switch url {
            case .success(let url):
                self.instagramStoriesVideo(url: url)
            case .failure(let error):
                print(error.localizedDescription)
            }
          })
    }
    
// swiftlint:disable all
        func instagramStoriesVideo(url: URL) {
//            let url = Bundle.main.url(forResource: "video1", withExtension: "mp4")!
            if let urlScheme = URL(string: "instagram-stories://share") {
                if UIApplication.shared.canOpenURL(urlScheme) {
                    let videoData: Data = try! Data(contentsOf: url)
                    let items = [["com.instagram.sharedSticker.backgroundVideo": videoData]]
                    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]
                // 5
                UIPasteboard.general.setItems(items, options: pasteboardOptions)
                // 6
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
            }
        }
    }
}
// swiftlint:enable all

extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
