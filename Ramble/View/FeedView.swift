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
    @EnvironmentObject var selectedRamb: SelectedRamb
    @EnvironmentObject var settings: SessionSettings
    
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var locationManager = LocationManager()
    
    @State var recordingModal_shown = false
    @State var myprofileModal_shown = false
    @State var locationModal_shown = false
    
    //    @State var userprofileModal_shown = false
    
    @State var dataSelector = 0
    
    var feedtoggle = ["Hot", "New"]
    var user: User
    
    @State var ramb: Ramb?
    
    init(user: User, audioRecorder: AudioRecorder) {
        UISegmentedControl.appearance().selectedSegmentTintColor = .red
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.red], for: .normal)
        
        self.user = user
        self.audioRecorder = audioRecorder
    }
    
    
    var body: some View {
        
        ZStack{
            
            NavigationView{
                
                VStack{
                    
                    VStack{
                        
                        ZStack{
                            
                                Picker(selection: $dataSelector, label: Text("")) {
                                    
                                    ForEach(0..<feedtoggle.count) { index in
                                    
                                        Text(self.feedtoggle[index]).tag(index)
                                    
                                    }
                                
                                }.pickerStyle(SegmentedPickerStyle()).frame(width: 150)
                                                            
                            HStack{
                                
                                Text("RAMBLE")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .offset(x: (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.left)!)
                                
                                Spacer()
                                                                                        
                                Button(action: {
                                    
                                    self.recordingModal_shown.toggle()
                                    
                                }){
                                    
                                    Image(systemName: "mic.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    }.buttonStyle(BorderlessButtonStyle())
                            }
                                .padding()
                                .accentColor(.red)

                        }
                                                
                    }
                    
                    RambFeed(RambService(), dataToggle: $dataSelector)
                    
                }
                
            }.navigationBarHidden(false)
            
                HalfModalView(isShown: $recordingModal_shown, modalHeight: 400){
                RecordPopOverView(audioRecorder: AudioRecorder(), isShown: self.$recordingModal_shown)
            
            }
            
            //            HalfModalView(isShown: $myprofileModal_shown){
            //                MyProfileView(isShown: self.$myprofileModal_shown, user: self.user)
            //            }
            
            //            HalfModalView(isShown: $selectedRamb.userProfileShown){
            //                UserProfileView(isShown: self.$selectedRamb.userProfileShown, user: self.selectedRamb.user ?? self.user)
            //            }
            
            //            HalfModalView(isShown: $locationModal_shown, modalHeight: 300){
            //                LocationView()
            //            }
            
        }.environmentObject(selectedRamb)
            .environmentObject(SessionSettings())
    }
}
