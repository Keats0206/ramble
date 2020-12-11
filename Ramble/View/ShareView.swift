//
//  ShareView.swift
//  Ramble
//
//  Created by Peter Keating on 12/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import UIKit
import UIImageColors

struct ShareView: View {
    @EnvironmentObject var settings: SessionSettings
    @ObservedObject var shareService = ShareService()
    @ObservedObject var globalPlayer = GlobalPlayer()

    @State var profileImage: UIImage?
    @State private var shareHeight = UIScreen.main.bounds.height * 0.6
    @State private var shareWidth = UIScreen.main.bounds.width * 0.8
    @State private var imageSize = UIScreen.main.bounds.width * 0.6
    
    var ramb: Ramb2
    var user: User
    
    func createShareImage(inImage: UIImage, ramb: Ramb2) -> UIImage {
        let username = NSString(string: "\(ramb.user.username)")
        let title = NSString(string: "\(ramb.caption)")
        let logo = UIImage(named: "icon")!
        let website = NSString("www.useramble.com")
                
        //      Username attributes
        let atPoint1 = CGPoint(x: 60, y: inImage.size.height - 400)
        let textColor1 = UIColor.white.withAlphaComponent(0.5)
        let textFont1 = UIFont(name: "Helvetica Bold", size: 80)!
        let textFontAttributes1 = [
            NSAttributedString.Key.font: textFont1,
            NSAttributedString.Key.foregroundColor: textColor1,
        ]
        
        //      Title attributes
        let atPoint2 = CGPoint(x: 60, y: inImage.size.height - 300)
        let textColor2 = UIColor.white
        let textFont2 = UIFont(name: "Helvetica Bold", size: 105)!
        let textFontAttributes2 = [
            NSAttributedString.Key.font: textFont2,
            NSAttributedString.Key.foregroundColor: textColor2,
        ]
        
        //      Ramble signuiture attributes
        let atPoint3 = CGPoint(x: 160, y: inImage.size.height - 100)
        let textColor3 = UIColor.white.withAlphaComponent(0.5)
        let textFont3 = UIFont(name: "Helvetica", size: 60)!
        let textFontAttributes3 = [
            NSAttributedString.Key.font: textFont3,
            NSAttributedString.Key.foregroundColor: textColor3,
        ]
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        // Put the image into a rectangle as large as the original image
        
//      Create gradient covering entire image
        
//      Draw in profile image
        
//      Draw in title
        
//      Draw in caption
        
//      Draw in volume image
        
//      Draw in footer image
        
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        logo.draw(in: CGRect(x: 60, y: inImage.size.height - 100, width: 75, height: 75))
        
        // Create a point within the space that is as big as the image
        let rect1 = CGRect(x: atPoint1.x, y: atPoint1.y, width: inImage.size.width, height: inImage.size.height)
        username.draw(in: rect1, withAttributes: textFontAttributes1)
        let rect2 = CGRect(x: atPoint2.x, y: atPoint2.y, width: inImage.size.width, height: inImage.size.height)
        title.draw(in: rect2, withAttributes: textFontAttributes2)
        let rect3 = CGRect(x: atPoint3.x, y: atPoint3.y, width: inImage.size.width, height: inImage.size.height)
        website.draw(in: rect3, withAttributes: textFontAttributes3)
        
        // Get the Graphics Context
        let context = UIGraphicsGetCurrentContext()
        UIColor.black.setFill()
        context?.setAlpha(0.2)
        context?.setFillColor(UIColor.black.cgColor)
        context?.addRect( CGRect(x: 0, y: inImage.size.height - 600, width: inImage.size.width, height: 600))
        context?.fillPath()
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
    }
    
    var body: some View {
        LoadingView(isShowing: $shareService.isLoading) {
            ZStack(alignment: .top) {
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "speaker.3.fill")
                            .font(.body)
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }.padding()
                    HStack {
                        Spacer()
                        NetworkImage(url: URL(string: user.profileImageUrl), image: profileImage)
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        VStack(alignment: .center) {
                            Text("\(ramb.caption)")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(settings.thirdColor)
                            Text("\(ramb.user.displayname)")
                                .font(.headline)
                                .foregroundColor(settings.fourthColor)
                        }
                    }
                    Spacer()
                    HStack {
                        Image("icon")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("www.useramble.com")
                            .font(.caption)
                            .opacity(0.5)
                    }.padding()
                        .foregroundColor(.white)
                }
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [settings.firstColor, settings.secondColor]),
                        center: .center,
                        startRadius: 2,
                        endRadius: 650)
                )
                .frame(width: shareWidth, height: shareHeight)
                .cornerRadius(20)
                Spacer()
                Divider()
                HStack {
                    Text("Instagram Stories")
                    Spacer()
                    Button(action: {
                        shareService.shareToSocial(
                            ramb: testRamb,
                            image: self.createShareImage(inImage: settings.userUIImage, ramb: testRamb),
                            social: SocialPlatform.instagram)
                    }) {
                        Text("Share")
                            .font(.headline)
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
                .padding()
            }
            .padding()
        }
        }
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(ramb: testRamb, user: testUser)
    }
}
