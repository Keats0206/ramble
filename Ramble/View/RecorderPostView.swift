//
//  RecorderPostView.swift
//  Ramble
//
//  Created by P..D..! on 14/10/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct RecorderPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var audioRecorder = AudioRecorder()

    @State var caption = ""
    @State var rambUrl: String
    @Binding var currentTab: Tab
    
    var user: User
    
    func uploadRamb2(user: User, caption: String, rambUrl: String, fileId: String){
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let isSelected = false
        let length = Double(0)
        let uid = user.id!
        
        let ramb = Ramb2(caption: caption, length: length, rambUrl: rambUrl, fileId: fileId, timestamp: timestamp, plays: 0, user: user, uid: uid, isSelected: isSelected)
        
        RambService2().addRamb(ramb)
    }

    var body: some View {
        
        VStack(alignment: .center){
            
            TextField("What do you have to say", text: $caption)
                .font(.system(.largeTitle,design: .rounded))
                .fixedSize(horizontal: true, vertical: false)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: {
                print("Play ramb")
            }){
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.accent3)
            }
            
            Spacer()
        
        }.padding()
        .navigationBarItems(trailing:
            Button(action: {
                self.uploadRamb2(
                    user: user,
                    caption: caption,
                    rambUrl: rambUrl,
                    fileId: ""
                )
                self.currentTab = Tab.profile
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Post")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(.accent4)
            }
        )
    }
}


struct RecorderPostView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderPostView(rambUrl: "", currentTab: .constant(Tab.Tab1), user: User(id: "1",
                                                                                  uid: "1",
                                                                                  email: "testing@gmail.com",
                                                                                  username: "Testuser",
                                                                                  displayname: "Testuser",
                                                                                  profileImageUrl: "https://electrek.co/wp-content/uploads/sites/3/2020/08/Tesla-Elon-Musk.jpg?quality=82&strip=all",
                                                                                  bio: "Hey, I'm a test user this my bio",
                                                                                  isFollowed: true
        ))
    }
}
