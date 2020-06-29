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
    
    @State private var recordingModal_shown = false
    @State private var profileModal_shown = false
    @State private var locationModal_shown = false
    
//    How can I use thise state toggle to chage what data is displayed??? hmmmm
    
    @State var dataSelector = 0
    var feedtoggle = ["Hot", "New"]
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    // UI built without navigation view...just one App view, and all popover views.
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                                    
                    Spacer()
                    
                    HStack{
                        
                        Text("Ramble")
                        
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
                            self.profileModal_shown.toggle()
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
                
                if dataSelector == 0{
                    RambHotFeed()
                } else {
                    RambNewFeed()
                }
            }
            
            HalfModalView(isShown: $recordingModal_shown, modalHeight: 400
            ){
                RecordPopOverView(audioRecorder: AudioRecorder())
            }
                        
            HalfModalView(isShown: $profileModal_shown
            ){
                ProfileView(isShown: self.$profileModal_shown)
            }
            
            HalfModalView(isShown: $locationModal_shown, modalHeight: 300
            ){
                LocationView()
            }
        }
    }
}

