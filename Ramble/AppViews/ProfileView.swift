//
//  ProfileView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//
import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {

        NavigationView {
            
            ZStack(){
                
                ProfileHeader()
                                
                SlideOverCard {
                    RecordPopOverView(audioRecorder: AudioRecorder())
                    
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(audioRecorder: AudioRecorder())
    }
}


        
        
        
        
        
