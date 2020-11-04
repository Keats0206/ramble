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
    
    @State var showActionSheet = false
    
    @State var hideNav = false
    
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        NavigationView{
            ZStack {
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
                    Button(action: {
                        self.showActionSheet.toggle()
                    }) {
                        Circle()
                            .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                            .frame(width: 25, height: 25)
                            .overlay(Image(systemName: "line.horizontal.3.decrease.circle")
                                        .foregroundColor(Color.flatDarkBackground))
                    }.actionSheet(isPresented: self.$showActionSheet, content: {
                        ActionSheet(title: Text("Select an option"), buttons: [
                                        .default(Text("Most Recent")) {self.dataToggle = 0},
                                        .default(Text("Most Plays")) {self.dataToggle = 1},
                                        .cancel()])
                    }
                )
            )
        }
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
