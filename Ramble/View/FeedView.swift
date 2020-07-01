//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 6/15/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI


struct FeedView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var locationManager = LocationManager()
        
    @State var recordingModal_shown = false
    @State var myprofileModal_shown = false
    @State var locationModal_shown = false
    @State var userprofileModal_shown: Bool = false
        
    @State var dataSelector = 0
        
    var feedtoggle = ["Hot", "New"]
   
    var user: User
    
//  Create a other user profile view that takes in a uid
    
//  Create a half modal wrap around that view
    
//  Send user uid from ramble cell up to feed view
    
//  If uid is not current user - open half model and pass in uid, if uid is current user do nothing/print some message...
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                                    
                    Spacer()
                    
                    HStack{
                        
                        Text("RambleOn")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        HStack {
                            Picker(selection: $dataSelector, label: Text("")) {
                                ForEach(0..<feedtoggle.count) { index in
                                    Text(self.feedtoggle[index]).tag(index)
                                }
                            }.pickerStyle(SegmentedPickerStyle()).frame(width: 150)
                        }

                        Spacer()
                        
                        Button(action: {
                            self.locationModal_shown.toggle()
                        }){
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            self.myprofileModal_shown.toggle()
                        }){
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            self.recordingModal_shown.toggle()
                        }){
                            Image(systemName: "mic.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }.buttonStyle(BorderlessButtonStyle())
                    }.padding([.top, .leading, .trailing]).accentColor(.red)
                }.frame(height: 100)
                                    
                RambFeed(RambService(), dataToggle: $dataSelector)
                
            }
            
            HalfModalView(isShown: $recordingModal_shown, modalHeight: 400){
                RecordPopOverView(audioRecorder: AudioRecorder())
            }
                        
            HalfModalView(isShown: $myprofileModal_shown){
                MyProfileView(isShown: self.$myprofileModal_shown, user: self.user)
            }
            
            HalfModalView(isShown: $userprofileModal_shown){
                UserProfileView(isShown: self.$userprofileModal_shown, user: self.user)
            }
                        
            HalfModalView(isShown: $locationModal_shown, modalHeight: 300){
                LocationView()
            }
        }
    }
}
