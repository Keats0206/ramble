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
//
//    init() {
//    // For navigation bar background color
//        UINavigationBar.appearance().backgroundColor = .clear
//       }
    
    var body: some View {

        NavigationView {
            
            ZStack(){
                
                FeedView()
                
                SlideOverCard {
                    PlayerViewPopOver()
                }
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
