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

    @State var profileImage: UIImage?
    @State private var shareHeight = UIScreen.main.bounds.height * 0.6
    @State private var shareWidth = UIScreen.main.bounds.width * 0.8
    @State private var imageSize = UIScreen.main.bounds.width * 0.6
    
    var ramb: Ramb2
    var user: User
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!
            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

            return image
        }
    
    
    func createShareImage(ramb: Ramb2) -> UIImage {
        let inImage = UIImage(named: "ramble")!
        let username = NSString(string: "\(ramb.user.displayname)")
        let title = NSString(string: "\(ramb.caption)")
        let logo = UIImage(named: "icon")!
        let userImage = cropToBounds(image: settings.userUIImage, width: 1200, height: 1200)
                            .withRoundedCorners(radius: 50)!
        
                        
//      Used to center text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        //      User image attributes
        let imgAtPoint = CGPoint(x: 200, y: inImage.size.height * 0.2)
                
        //      Title attributes
        let atPoint2 = CGPoint(x: 0, y: inImage.size.height * 0.7)
        let textColor2 = UIColor.white
        let textFont2 = UIFont.systemFont(ofSize: 160, weight: UIFont.Weight.bold)
        let textFontAttributes2 = [
            NSAttributedString.Key.font: textFont2,
            NSAttributedString.Key.foregroundColor: textColor2,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
//      Display name attributes
        let atPoint1 = CGPoint(x: 0, y: inImage.size.height * 0.77)
        let textColor1 = UIColor.white
        let textFont1 = UIFont.systemFont(ofSize: 105, weight: UIFont.Weight.medium)
        let textFontAttributes1 = [
            NSAttributedString.Key.font: textFont1,
            NSAttributedString.Key.foregroundColor: textColor1,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        //      Ramble signuiture attributes
        let website = NSString("www.useramble.com")
        let atPoint3 = CGPoint(x: 0, y: inImage.size.height - 300)
        let textColor3 = UIColor.white.withAlphaComponent(0.5)
        let textFont3 = UIFont.systemFont(ofSize: 80, weight: UIFont.Weight.medium)
        let textFontAttributes3 = [
            NSAttributedString.Key.font: textFont3,
            NSAttributedString.Key.foregroundColor: textColor3,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        UIGraphicsBeginImageContext(inImage.size)
        let context = UIGraphicsGetCurrentContext()
        inImage.draw(at: CGPoint(x: 0, y: 0))
        
        //      Gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let top = settings.firstColor.uiColor().cgColor
        let bottom = settings.secondColor.uiColor().cgColor
        let colors = [top, bottom] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        let startPoint = CGPoint(x: inImage.size.width / 2, y: 0)
        let endPoint = CGPoint(x: inImage.size.width / 2, y: inImage.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        logo.draw(in: CGRect(x: 60, y: inImage.size.height - 100, width: 75, height: 75))
        userImage.draw(in: CGRect(x: imgAtPoint.x, y: imgAtPoint.y, width: 1200, height: 1200))

        let rect1 = CGRect(x: atPoint1.x, y: atPoint1.y, width: inImage.size.width, height: inImage.size.height)
        username.draw(in: rect1, withAttributes: textFontAttributes1)
        let rect2 = CGRect(x: atPoint2.x, y: atPoint2.y, width: inImage.size.width, height: inImage.size.height)
        title.draw(in: rect2, withAttributes: textFontAttributes2)
        let rect3 = CGRect(x: atPoint3.x, y: atPoint3.y, width: inImage.size.width, height: inImage.size.height)
        website.draw(in: rect3, withAttributes: textFontAttributes3)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
        
    var body: some View {
        LoadingView(isShowing: $shareService.isLoading) {
            ZStack(alignment: .top) {
                
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack {
                        HStack {
                            Spacer()
//                            Image(systemName: "speaker.3.fill")
//                                .font(.body)
//                                .foregroundColor(.white)
//                                .opacity(0.5)
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
                                    .foregroundColor(.white)
                                Text("\(ramb.user.displayname)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        HStack {
                            Text("www.useramble.com")
                                .font(.caption)
                                .opacity(0.5)
                        }.padding()
                            .foregroundColor(.white)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [settings.firstColor, settings.secondColor]), startPoint: .top, endPoint: .bottom))
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
                                image: self.createShareImage(ramb: ramb),
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
//            swiftlint:disable large_tuple
//            swiftlint:disable identifier_name
extension Color {
    func uiColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }
        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0,
            g: CGFloat = 0.0,
            b: CGFloat = 0.0,
            a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
//            swiftlint:enable large_tuple
//            swiftlint:enable identifier_name
struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(ramb: testRamb, user: testUser)
    }
}
