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
    @State var length: Double
    @Binding var currentTab: Tab
    
    var user: User
    
    func uploadRamb2(user: User, caption: String, rambUrl: String, fileId: String, length: Double){
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let isSelected = false
        let length = length
        let uid = user.id!
        let ramb = Ramb2(caption: caption, length: length, rambUrl: rambUrl, fileId: fileId, timestamp: timestamp, plays: 0, user: user, uid: uid, isSelected: isSelected)
        RambService2().addRamb(ramb)
    }
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            TextField("Untitled ramb", text: $caption)
                .frame(width: 300)
                .multilineTextAlignment(.leading)
                .font(.system(.body, design: .rounded))
                .fixedSize(horizontal: true, vertical: false)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: {
                print("Play ramb")
            }) {
                Image(systemName: "play.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .foregroundColor(Color.accent3)
            }
            
            Text(String(format: "%.1f", length))
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .padding(.top, 300)

        }.padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .foregroundColor(.accent3)
                        .frame(width: 25, height: 25)

                    }, trailing:
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
                HStack {
                    Text("POST")
                        .font(.system(.headline, design: .rounded))
                        .bold()
                        .foregroundColor(.accent4)
                    Image(systemName: "plus")
                        .foregroundColor(.accent4)
                        .frame(width: 25, height: 25)
                    }
                }
            )
        }
    }

struct RecorderPostView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderPostView(rambUrl: "", length: 300, currentTab: .constant(Tab.tab1), user: User(id: "1",
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
