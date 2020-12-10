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

enum SocialPlatform {
    case instagram
    case snapchat
    case twitter
    case facebook
}

// swiftlint:disable all
class ShareService: ObservableObject {
    static let shared = ShareService()
    
    @Published var isLoading: Bool = false
    @Published var wasError: Bool = false

    func shareToSocial(ramb: Ramb2, social: SocialPlatform) {
        isLoading.toggle()
        let inImage = UIImage(imageLiteralResourceName: "shareimage")
//        let textImage = textToImage(inImage: inImage, ramb: ramb)
//        let finalImage = cropToBounds(image: textImage, width: 100, height: 100)
        let audioData = ramb.fileUrl
        
        VideoGenerator.current.generate(withImages: [inImage], andAudios: [audioData], andType: .single, { (progress) in
            print(progress)
        }, outcome: { [self] (url) in
            switch url {
            case .success(let url):
                self.instagramStoriesVideo(url: url)
                isLoading = false
                print("Share to IG success")
            case .failure(let error):
                print("Share to IG fail because: \(error.localizedDescription)")
                isLoading = false
                wasError = true
            }
        })
    }
    
    func shareToFacebookStories(ramb: Ramb2) {
//        let photo = SharePhoto(image: image!, userGenerated: true)
//        let content = SharePhotoContent()
//        content.photos = [photo]
//        let showDialog = ShareDialog(fromViewController: self, content: content, delegate: self)
//
//        if (showDialog.canShow) {
//            showDialog.show()
//        } else {
//            self.view.makeToast("It looks like you don't have the Facebook mobile app on your phone.")
//        }
    }
    
    func shareToTwitterStories(ramb: Ramb2) {
        print("Shared to Twitter")
    }
    
    func shareToSnapStories(ramb: Ramb2) {
        print("Shared to Twitter")
    }
    
//      Create a video with the audio and an image
    
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
    
//  func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
//            let cgimage = image.cgImage!
//            let contextImage: UIImage = UIImage(cgImage: cgimage)
//            let contextSize: CGSize = contextImage.size
//            var posX: CGFloat = 0.0
//            var posY: CGFloat = 0.0
//            var cgwidth: CGFloat = CGFloat(width)
//            var cgheight: CGFloat = CGFloat(height)
//
//            // See what size is longer and create the center off of that
//            if contextSize.width > contextSize.height {
//                posX = ((contextSize.width - contextSize.height) / 2)
//                posY = 0
//                cgwidth = contextSize.height
//                cgheight = contextSize.height
//            } else {
//                posX = 0
//                posY = ((contextSize.height - contextSize.width) / 2)
//                cgwidth = contextSize.width
//                cgheight = contextSize.width
//            }
//
//            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
//
//            // Create bitmap image from context using the rect
//            let imageRef: CGImage = cgimage.cropping(to: rect)!
//
//            // Create a new image based on the imageRef and rotate back to the original orientation
//            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
//
//            return image
//        }
    
//  func snapStoriesVideo(url: URL) {
//        let videoUrl = url
//        let video = SCSDKSnapVideo(videoUrl: videoUrl)
//        let videoContent = SCSDKSnapVideoContent(snapVideo: video)
//
//        let api = SCSDKSnapAPI(content: snap)
//        api.startSnapping { error in
//
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                // success
//
//            }
//        }
//    }
    
//  func facebookStoriesVideo(url: URL) {
//
//    }
    
//  func facebookStoriesVideo(url: URL) {
//
//    }
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
