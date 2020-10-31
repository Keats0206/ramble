//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 6/15/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var userModel = UserService2()
    
    @State var recordingModalShown = false
    @State var searchModalShown = false
    @State var dataToggle = 0
    @State var ramb: Ramb2?
    
    @State var hideNav = false
    
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        ZStack{
            RambFeed(dataToggle: $dataToggle)
        }
        .navigationBarHidden(hideNav)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            leading:
                HStack {
                    Text("RAMBLE")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.accent3)
                },
            trailing:
                HStack {
                    Circle()
                        .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                        .frame(width: 25, height: 25)
                        .overlay(Image(systemName: "line.horizontal.3.decrease.circle").foregroundColor(Color.flatDarkBackground))
                        .contextMenu {
                            Button(action: {
                                self.dataToggle = 1
                            // Action will goes here
                            }) {
                                Text("Most Plays")
                                Image(systemName: dataToggle == 1 ? "flame.fill" : "flame")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                            }.foregroundColor(dataToggle == 1 ? Color.accent4 : Color.flatDarkCardBackground)
                            Button(action: {
                                self.dataToggle = 0
                            }) {
                                Text("Most Recent")
                                Image(systemName: dataToggle == 0 ? "clock.fill" : "clock")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                
                                }.foregroundColor(dataToggle == 1 ? Color.accent4 : Color.flatDarkCardBackground)
                    }
                }
            )
        }
    }

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(user: testUser)
            .environmentObject(SessionStore())
            .environmentObject(GlobalPlayer())
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Circle()
                    .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                    .frame(width: 25, height: 25)
                    .overlay(Image(systemName: "arrowshape.turn.up.left")
                        .foregroundColor(Color.flatDarkBackground))
            }
        }
    }
}
