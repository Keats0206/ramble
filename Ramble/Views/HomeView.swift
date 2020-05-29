//
//  HomeView.swift
//  Ramble
//
//  Created by Peter Keating on 4/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
            
    var body: some View {

        NavigationView {
            
            ZStack(){
                
                FeedView()
                
                SlideOverCard {
                    RecordPopOverView(audioRecorder: AudioRecorder())
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(audioRecorder: AudioRecorder())
    }
}
