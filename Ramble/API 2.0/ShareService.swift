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
import Firebase


class ShareService: ObservableObject {
    static let shared = ShareService()
    
    @Published var isLoading: Bool = false
    @Published var wasError: Bool = false
    
    func shareToIGLocal(ramb: Ramb2) {
        isLoading.toggle()
        let imageData = UIImage(imageLiteralResourceName: "rambleexport")
        let audioData = ramb.fileUrl
        VideoGenerator.current.generate(withImages: [imageData], andAudios: [audioData], andType: .single, { (progress) in
            print(progress)
        }, outcome: { [self] (url) in
            switch url {
            case .success(let url):
                self.instagramStoriesVideo(url: url)
                isLoading = false
                print("Share to IG success")
            case .failure(let error):
                print(error.localizedDescription)
                isLoading = false
                wasError = true
                print("Share to IG failure")
            }
        })
    }
//      Create a video with the audio and an image
// swiftlint:disable all
    func instagramStoriesVideo(url: URL) {
            if let urlScheme = URL(string: "instagram-stories://share") {
                if UIApplication.shared.canOpenURL(urlScheme) {
                    let videoData: Data = try! Data(contentsOf: url)
                    let items = [["com.instagram.sharedSticker.backgroundVideo": videoData]]
                    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]
                    UIPasteboard.general.setItems(items, options: pasteboardOptions)
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
//    func downloadAudio(ramb: Ramb2) {
//        print(self.shareState)
//        let imageData = UIImage(imageLiteralResourceName: "ramble")
//        let id = "05F6A6BD-921E-427F-BC50-A7E1C0D7F53C"
//        let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
//        // Create a reference to the file you want to download
//        let rambStorageRef = Storage.storage().reference(forURL: ramb.rambUrl)
//        // Create local filesystem URL
//        let localURL = tmporaryDirectoryURL.appendingPathComponent("\(ramb.id).m4a")
//        // Download to the local filesystem
//        let downloadTask = rambStorageRef.write(toFile: localURL) { url, error in
//            if let error = error {
//                print(error.localizedDescription)
//        // Uh-oh, an error occurred!
//            } else {
//                VideoGenerator.current.generate(withImages: [imageData], andAudios: [localURL], andType: .single, { (progress) in
//                    print(progress)
//                }, outcome: { (url) in
//                    switch url {
//                    case .success(let url):
//        //      Video generated succesfully share to IG
//                        self.instagramStoriesVideo(url: url)
//                        print(self.shareState)
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        print(self.shareState)
//                    }
//                })
//            }
//        }
//    }
