//
//  HomeView.swift
//  Ramble
//
//  Created by Peter Keating on 4/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import UIKit

struct FeedView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var userimage = ""
            
    var body: some View {
        
        NavigationView{
            
            ZStack(){
                
                RambFeed()
                
                SlideOverCard {
                    
                    RecordPopOverView(audioRecorder: AudioRecorder())
                    
                }
                
            }.navigationBarTitle("Ramble",displayMode: .inline)
            .navigationBarItems(leading:
            
                Image(userimage).resizable().frame(width: 35, height: 35).clipShape(Circle()).onTapGesture {
                    
                    print("slide out menu ....")
                }
            )
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(audioRecorder: AudioRecorder())
    }
}
