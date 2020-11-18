//
//  RecorderPostView.swift
//  Ramble
//
//  Created by P..D..! on 14/10/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct RecorderPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var audioRecorder = AudioRecorder()

    @State var caption = ""
    @State var rambUrl: String
    @State var length: Double
    @Binding var currentTab: Tab
    
    var imageScale = UIScreen.main.bounds.width * 0.7
    
    var user: User
    
    func uploadRamb2(user: User, caption: String, rambUrl: String, fileId: String, length: Double){
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let isSelected = false
        let length = length
        let uid = user.id!
        let ramb = Ramb2(caption: caption, length: length, rambUrl: rambUrl, fileId: fileId, timestamp: timestamp, plays: 0, user: user, uid: uid, isSelected: isSelected)
        RambService2().addRamb(ramb)
    }
    
    static let rambDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }()
        var postDate = Date()
    
    var body: some View {
        VStack(alignment: .center) {
            
            WebImage(url: URL(string: "\(user.profileImageUrl)"))
                .resizable()
                .scaleEffect()
                .frame(width: imageScale, height: imageScale)
                .clipShape(Rectangle())
                .cornerRadius(8)
            
            Spacer()
            
            TextField("Untitled Ramb - \(postDate, formatter: Self.rambDateFormat)", text: $caption)
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .rounded))
            
            Spacer()
            
            AudioControlView(player: AVPlayer(url: URL(string: rambUrl)!))
                .padding()
            
            Spacer()
            
            Button(action: {
                self.uploadRamb2(
                    user: user,
                    caption: caption,
                    rambUrl: rambUrl,
                    fileId: "",
                    length: length
                )
                self.currentTab = Tab.profile
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("POST")
                    .font(.system(.headline, design: .rounded))
                    .bold()
                
            }.padding()
            .padding(.horizontal, 30)
            .foregroundColor(.white)
            .background(Color.accent3)
            .cornerRadius(40)
                            
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.accent3)
                }
            )
        }
    }

struct RecorderPostView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderPostView(
            rambUrl: testRamb.rambUrl,
            length: testRamb.length,
            currentTab: .constant(Tab.tab1),
            user: testUser
        )
    }
}
