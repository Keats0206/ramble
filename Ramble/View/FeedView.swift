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
    @ObservedObject var userModel = UserService()
    
    @State var recordingModal_shown = false
    @State var searchModal_shown = false
    @State var dataSelector = 0
    @State var ramb: Ramb?
    
    @State var hideNav = false

    private var feedtoggle = ["Hot", "New"]
    
    var user: User
        
    init(user: User) {
//        UISegmentedControl.appearance().selectedSegmentTintColor = .red
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.red], for: .normal)
//        
        self.user = user
    }
    
    var body: some View {
            ZStack{
                     
                RambFeed(RambService(), dataToggle: $dataSelector)
                
                FloatingPlayerView(hideNav: $hideNav)
                    .edgesIgnoringSafeArea(.all)
                
//                ZStack{
//                    SearchView(isPresented: $searchModal_shown, hideNav: $hideNav)
//                }.edgesIgnoringSafeArea(.all)
//                .offset(x: 0, y: self.searchModal_shown ? 10 : UIApplication.shared.currentWindow?.frame.height ?? 0)
////
//                HalfModalView(isShown: $recordingModal_shown, modalHeight: 400){
//                    RecordPopOverView(audioRecorder: AudioRecorder(), isShown: self.$recordingModal_shown, hideNav: $hideNav)
//                }
            
            }.navigationBarHidden(hideNav)
            .navigationBarTitle("Feed")
            .navigationBarItems(trailing: HStack{
                    Button(action: {
                        self.searchModal_shown.toggle()
                    }){
                        Image(systemName: "magnifyingglass")
                            .padding(5)
                    }.background(Capsule().fill(Color.black).opacity(0.2))
                    .sheet(isPresented: $searchModal_shown, onDismiss: {
                        print("Modal dismisses")
                    }) {
                        NavigationView{
                            SearchView()
                        }
                    }
                
                    Button(action: {
                        self.recordingModal_shown.toggle()
                    }){
                        Image(systemName: "mic.circle")
                            .padding(5)
                    }.background(Capsule().fill(Color.black).opacity(0.2))
                    .sheet(isPresented: $recordingModal_shown, onDismiss: {
                        print("Modal dismisses")
                    }) {
                        NavigationView{
                            RecorderView(audioRecorder: AudioRecorder())
                        }
                    }
            })
//            .navigationBarItems(leading: HStack{
//                    Picker(selection: $dataSelector, label: Text("")) {
//                        ForEach(0..<feedtoggle.count) { index in
//                            Text(self.feedtoggle[index]).tag(index)
//                       }
//                  }.pickerStyle(SegmentedPickerStyle()).frame(width: 150)
//            })
        }
}
