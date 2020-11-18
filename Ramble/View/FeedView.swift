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
    @State var currentTab = Tab.tab1
    @State var showActionSheet = false
    @State var hideNav = false
    
    @Binding var actionState: Int?
    @Binding var selectedUser: User
    
    var user: User

    init(user: User, actionState: Binding<Int?>, selectedUser: Binding<User>) {
        self.user = user
        self._actionState = actionState
        self._selectedUser = selectedUser
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                
                NavigationLink(destination: ProfileView(user: selectedUser), tag: 1, selection: $actionState) {
                    EmptyView()
                }
                
                RambFeed(dataToggle: $dataToggle)
                    .environmentObject(globalPlayer)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Text("RAMBLE")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(Color.primary)
                    },
                trailing:
                    HStack {
                        Button(action: {
                            self.recordingModalShown.toggle()
                        }) {
                            Image(systemName: "music.mic")
                                .resizable()
                                .foregroundColor(Color.accent3)
                                .frame(width: 25, height: 25)
                        }.sheet(isPresented: self.$recordingModalShown, content: {
                            NavigationView {
                                RecorderView(currentTab: $currentTab, user: user)
                            }
                        })
                        
                        if #available(iOS 14.0, *) {
                            Menu {
                                Picker(selection: $dataToggle, label: Text("Sorting options")) {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(Color.accent4)
                                        Text("Most Recent")
                                            .foregroundColor(Color.accent4)
                                    }
                                    .tag(0)
                                    
                                    HStack {
                                        Image(systemName: "flame.fill")
                                        Text("Most Plays")
                                    }.tag(1)
                                }
                            }
                            label: {
                                Image(systemName: "music.note.list")
                                    .resizable()
                                    .foregroundColor(Color.accent3)
                                    .frame(width: 25, height: 25)
                            }
                        } else {
                            // Fallback on earlier versions
                            Button(action: {
                                self.showActionSheet.toggle()
                            }) {
                                Image(systemName: "music.note.list")
                                    .resizable()
                                    .foregroundColor(Color.accent3)
                                    .frame(width: 25, height: 25)
                            }.actionSheet(isPresented: self.$showActionSheet, content: {
                                ActionSheet(title: Text("Select an option"), buttons: [
                                    .default(Text("Most Recent")) {self.dataToggle = 0},
                                    .default(Text("Most Plays")) {self.dataToggle = 1},
                                    .cancel()])
                            }
                        )
                    }
                        NavigationLink(destination: ProfileView(user: user)) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundColor(Color.accent3)
                                .frame(width: 25, height: 25)
                        }
                }
            )
        }
    }
}
//
//struct FeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedView(user: testUser, actionState: Binding<0>)
//            .environmentObject(SessionStore())
//            .environmentObject(GlobalPlayer())
//    }
//}

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
